import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/CartPage.dart';


class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  final User? user;
  const CartScreen({super.key, this.user});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: CartPage(
        user: user,
      ),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.cart),
    );
  }
}
