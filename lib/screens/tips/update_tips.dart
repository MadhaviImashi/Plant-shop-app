import 'package:flutter/material.dart';
import '../../components/admin_nav.dart';
import '../../helper/admin_enum.dart';
import 'components/update_form.dart';

///Update tip data
class UpdateTips extends StatefulWidget {
  final String id;
  final String url;
  final String name;
  final String type;
  final String description;

  const UpdateTips(
      {super.key,
      required this.url,
      required this.name,
      required this.type,
      required this.description,
      required this.id});

  @override
  State<UpdateTips> createState() => _UpdateTipsState();
}

class _UpdateTipsState extends State<UpdateTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Tip"),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
            Image.network(widget.url, fit: BoxFit.fill),
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
                url: widget.url,
                type: widget.type,
                description: widget.description))
      ])),
        bottomNavigationBar:  const AdminNavBar(selectedMenu: AdminState.tips)
    );
  }
}
