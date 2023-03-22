import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/enums.dart';

///Home component which is stateful and store list of plants
class UserHome extends StatefulWidget {
  final User? user;
  const UserHome({super.key, required this.user});
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _formKey = GlobalKey<FormState>();

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Form(
            key: _formKey,
            child: ElevatedButton(
              child: const Text("Add plant to wishlish"),
              onPressed: () async {
                CollectionReference<Map<String, dynamic>> wishlistRef =
                    await FirebaseFirestore.instance
                        .collection('wishlist')
                        .doc(_currentUser.uid)
                        .collection('items');

                await wishlistRef.add({
                  'name': 'Plantora',
                  'imageUrl':
                      'https://images.unsplash.com/photo-1547575824-440930b53b4d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
                  'price': '100.00'
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.home, user: _currentUser),
    );
  }
}
