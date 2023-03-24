import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/snackbar.dart';


///Form to update an existing tip
class UpdateForm extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String type;

  const UpdateForm(
      {super.key,
        required this.name,
        required this.description,
        required this.type,
        required this.id});

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late String name = widget.name;
  late String description = widget.description;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  late String type = widget.type;
  late String id = widget.id;

  @override
  Widget build(BuildContext context) {
    setState(() {
      nameController.text = name;
      descriptionController.text = description;
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
              'Fern'
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
                  'description': descriptionController.text,
                  'type': type,
                }).whenComplete(() => snackBar(context, "Tip Successfully Updated"));
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
          return "Tip title is required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Tip Title",
        hintText: "Enter tip title here",
      ),
    );
  }

  TextFormField descriptionFormField() {
    return TextFormField(
      controller: descriptionController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Description is required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Description",
        hintText: "Enter description here",
      ),
    );
  }
}