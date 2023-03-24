import 'package:flutter/material.dart';
import '../../components/admin_nav.dart';
import '../../helper/admin_enum.dart';
import 'components/update_form.dart';


///Update existing tip details
class UpdateTips extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String type;

  const UpdateTips(
      {super.key,
      required this.name,
      required this.description,
      required this.type,
      required this.id});

  @override
  State<UpdateTips> createState() => _UpdateTipsState();
}

class _UpdateTipsState extends State<UpdateTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Tip Details"),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: UpdateForm(
                id: widget.id,
                name: widget.name,
                type: widget.type,
                description: widget.description))
      ])),
        bottomNavigationBar:  const AdminNavBar(selectedMenu: AdminState.tips)
    );
  }
}
