import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/helper/enums.dart';
import 'components/CartPage.dart';
import 'components/CheckoutPage.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: CartPage(),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.cart),
    );
  }
}
