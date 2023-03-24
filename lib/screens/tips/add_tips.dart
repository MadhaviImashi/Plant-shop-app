import 'package:flutter/material.dart';
import '../../components/admin_nav.dart';
import '../../helper/admin_enum.dart';
import './components/add_form.dart';

///Add new tip details
class AddTips extends StatelessWidget {

  const AddTips({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Tip"),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
            AddForm()
          ])),
      bottomNavigationBar:  const AdminNavBar(selectedMenu: AdminState.tips),
    );

  }
}