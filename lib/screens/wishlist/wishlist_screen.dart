import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/constants.dart';
import 'package:plant_shop_app/enums.dart';

import 'package:flutter_svg/svg.dart';
import '../../../size_config.dart';
// import './components/favorite_card.dart';

class WishlistScreen extends StatefulWidget {
  final User? user;
  const WishlistScreen({super.key, required this.user});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late User _currentUser;
  List<Map<String, dynamic>> wishlistData = List.empty();
  String? count = '0';

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Call the init method of the SizeConfig class
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('wishlist')
                .doc(_currentUser.uid)
                .collection('items')
                .snapshots()
                .map((snapshot) =>
                    snapshot.docs.map((doc) => doc.data()).toList()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              wishlistData = snapshot.data!;
              count = (wishlistData.length).toString();
              return ListView.builder(
                  itemCount: wishlistData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> itemData = wishlistData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                        key: Key(itemData['id'].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            wishlistData.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        child: FavoriteCard(
                            itemData: itemData, cUser: _currentUser),
                      ),
                    );
                  });
            }),
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedMenu: MenuState.favourite, user: _currentUser),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          const Text(
            "My Wishlist",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "$count items",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final User? cUser;

  const FavoriteCard({
    super.key,
    required this.itemData,
    required this.cUser,
  });

  final Map<String, dynamic> itemData;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 238, 250, 246),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 238, 250, 246),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(itemData['imageUrl']),
              ),
            ),
          ),
          const SizedBox(
              width: 20), //creates a gap between the img & details column
          Container(
            constraints: const BoxConstraints(
                minWidth: 190), // set the minimum width of the container,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemData['name'],
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "RS ${itemData['price']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                )
              ],
            ),
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/Trash.svg"),
            onPressed: () async {
              try {
                String itemName = itemData['name'].toString();
                print('item name: ${itemName}');

                QuerySnapshot itemQuerySnapshot = await FirebaseFirestore
                    .instance
                    .collection('wishlist')
                    .doc(cUser!.uid)
                    .collection('items')
                    .where('name', isEqualTo: itemName)
                    .get();
                if (itemQuerySnapshot.size == 0) {
                  print('Item not found in database!');
                  return;
                }
                String itemId = itemQuerySnapshot.docs[0].id;
                await FirebaseFirestore.instance
                    .collection('wishlist')
                    .doc(cUser!.uid)
                    .collection('items')
                    .doc(itemId)
                    .delete();
                print('Deleted item from database!');
              } catch (e) {
                print('Error deleting item: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
