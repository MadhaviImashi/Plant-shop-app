import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/helper/enums.dart';

import '../models/PlantModel.dart';
import 'CheckoutPage.dart';
import '../../../components/default_button.dart';

class CartPage extends StatefulWidget {
  final User? user;
  const CartPage({super.key, required this.user});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late String? user = widget.user?.uid;
  late User? us = widget.user;
  List<Map<String, dynamic>> _cartItems = [];
  List<Plant> _plants = [];
  double _totalPrice = 0.0;

  Future<List<Map<String, dynamic>>> _getCartItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Carts')
        .doc(user)
        .collection('Plants')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Plant>> _getPlants() async {
    return await Plant.getPlantsFromFirebase(user);
  }

  @override
  void initState() {
    super.initState();

    _getCartItems().then((cartItems) {
      setState(() {
        _cartItems = cartItems;
        _totalPrice = _cartItems.fold(0.0, (sum, item) => sum + item['price']);
      });
    });

    _getPlants().then((plants) {
      setState(() {
        _plants = plants;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          var item = _cartItems[index];
          var plant = _plants.firstWhere((p) => p.name == item['name']);

          // ignore: no_leading_underscores_for_local_identifiers
          void _updateCartItems(Plant plant, String itemName, int count) async {
            setState(() {
              var item =
                  _cartItems.firstWhere((item) => item['name'] == itemName);
              item['count'] = count;
              item['price'] = count * plant.price;
              _totalPrice =
                  _cartItems.fold(0.0, (sum, item) => sum + item['price']);
            });

            // Get the DocumentReference for the corresponding document in Firebase
            var docRef = FirebaseFirestore.instance
                .collection('Carts')
                .doc(user)
                .collection('Plants')
                .doc(plant.id);

            // Update the count and price in Firebase
            await docRef.update({
              'count': count,
              'price': count * plant.price,
            });
          }

          void _removeItemFromCart(String plantId, String itemName) async {
            setState(() {
              _cartItems.removeWhere((item) => item['name'] == itemName);
              _totalPrice =
                  _cartItems.fold(0.0, (sum, item) => sum + item['price']);
            });

            // Get the DocumentReference for the corresponding document in Firebase
            var docRef = FirebaseFirestore.instance
                .collection('Carts')
                .doc(user)
                .collection('Plants')
                .doc(plantId);

            // Delete the document from Firebase
            await docRef.delete();
          }

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(plant.imageUrl),
                ),
                title: Text(plant.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: \$${item['price'].toStringAsFixed(2)}'),
                    const SizedBox(height: 5),
                    Text(plant.description),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _updateCartItems(
                          plant, item['name'], item['count'] - 1),
                    ),
                    Text(item['count'].toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _updateCartItems(
                          plant, item['name'], item['count'] + 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _removeItemFromCart(plant.id, item['name']),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 200,
        child: Column(
          children: [
            // Main content of your page
            // ...
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text('Total: \$${_totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(height: 20),
                  DefaultButton(
                    text: "Checkout",
                    press: () {
                      final List<String> itemNames;
                      final List<int> itemPrices;

                      if (_cartItems.isNotEmpty) {
                        List<String> itemNames = [];
                        for (var item in _cartItems) {
                          itemNames.add(item['name']);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              totalPrice: _totalPrice,
                              itemName: itemNames,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.cart,
        user: us,
      ),
    );
  }
}
