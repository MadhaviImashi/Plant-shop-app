import 'dart:core';
import 'package:flutter/material.dart';
import '../../components/admin_nav.dart';
import '../../helper/admin_enum.dart';
import './components/view_card.dart';


//Admin home view for tips
class AdminTipHome extends StatefulWidget {
  const AdminTipHome({super.key});
  @override
  State<AdminTipHome> createState() => _AdminTipHomeState();
}

class _AdminTipHomeState extends State<AdminTipHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tips"),
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