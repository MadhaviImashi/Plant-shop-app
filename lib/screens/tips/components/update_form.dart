import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../components/snackbar.dart';

///Form to updaate tip
class UpdateForm extends StatefulWidget {
  final String id;
  final String url;
  final String name;
  final String type;
  final String description;

  const UpdateForm(
      {super.key,
      required this.url,
      required this.name,
      required this.type,
      required this.description,
      required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late String name = widget.name;
  late String desc = widget.description;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late String type = widget.type;
  late String url = widget.url;
  late String id = widget.id;

  @override
  Widget build(BuildContext context) {
    setState(() {
      nameController.text = name;
      descriptionController.text = desc;
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8), child: nameFormField()),
          Padding(
              padding: const EdgeInsets.all(8), child: descriptionFormField()),
          DropdownButtonFormField(
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                filled: false),
            value: type,
            onChanged: (String? newValue) {
              setState(() {
                type = newValue!;
              });
            },
            items: <String>[
              'Indoor',
              'Outdoor',
              'Fertilizer'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF58AF8B),
                foregroundColor: Colors.white),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FirebaseFirestore.instance.collection("Tips").doc(id).update({
                  'name': nameController.text,
                  'type': type,
                  'description': descriptionController.text,
                  'img': url
                }).whenComplete(() => snackBar(context, "Tip Updated"));
              } else {
                snackBar(context, "Error");
              }
            },
            child: const Text("Update Tip"),
          )
        ],
      ),
    );
  }

  TextFormField nameFormField() {
    return TextFormField(
      controller: nameController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Title";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Tip Title",
        hintText: "Enter Title",
      ),
    );
  }

  TextFormField descriptionFormField() {
    return TextFormField(
      controller: descriptionController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Description";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Description",
        hintText: "Enter Description",
      ),
    );
  }
}
