import 'dart:core';
import 'package:flutter/material.dart';

import '../../components/admin_nav.dart';
import '../../helper/admin_enum.dart';
import './components/view_card.dart';


//Admin home view
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: const [TipList()],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
        bottomNavigationBar:  const AdminNavBar(selectedMenu: AdminState.home),
    );
  }
}
