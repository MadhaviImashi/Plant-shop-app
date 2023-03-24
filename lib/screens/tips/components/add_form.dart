import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/snackbar.dart';


///Form to add a new tip
class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String type = 'Indoor';

  @override
  Widget build(BuildContext context) {
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
                FirebaseFirestore.instance.collection("Tips").add({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'type': type,
                }).whenComplete(() => snackBar(context, "Tip Successfully Added"));
              } else {
                snackBar(context, "Error");
              }
            },
            child: const Text("Add Tip"),
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
          return "Enter tip title here";
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
          return "Enter description here";
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
