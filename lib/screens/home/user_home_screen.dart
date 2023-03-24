import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/helper/enums.dart';
import 'package:plant_shop_app/screens/home/components/plant_card.dart';

import 'components/header.dart';

///Home component which is stateful and store list of plants
class UserHome extends StatefulWidget {
  final User? user;

  const UserHome({super.key, required this.user});
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Header(size), PlantCard(user: _currentUser.uid)],
        ),
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.home, user: _currentUser),
    );
  }
}
