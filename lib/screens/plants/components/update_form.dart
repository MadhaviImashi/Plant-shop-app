import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../components/snackbar.dart';

///Form to updaate plant
class UpdateForm extends StatefulWidget {
  final String id;
  final String url;
  final String name;
  final String type;
  final String description;
  final String price;
  final int rate;
  final String stock;

  const UpdateForm(
      {super.key,
      required this.url,
      required this.name,
      required this.type,
      required this.description,
      required this.price,
      required this.rate,
      required this.stock,
      required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late String name = widget.name;
  late String price = widget.description;
  late String desc = widget.price;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  late String type = widget.type;
  late String stock = widget.stock;
  late String url = widget.url;
  late int rate = widget.rate;
  late String id = widget.id;

  @override
  Widget build(BuildContext context) {
    setState(() {
      nameController.text = name;
      descriptionController.text = desc;
      priceController.text = price;
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8), child: nameFormField()),
          Padding(padding: const EdgeInsets.all(8), child: priceFormField()),
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
              'Pots',
              'Flowering',
              'Vines',
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
          DropdownButtonFormField(
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                filled: false),
            value: stock,
            onChanged: (String? newValue) {
              setState(() {
                stock = newValue!;
              });
            },
            items: <String>['available', 'Out of Stock']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF58AF8B),
                foregroundColor: Colors.white),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FirebaseFirestore.instance.collection("Plants").doc(id).update({
                  'name': nameController.text,
                  'type': type,
                  'price': priceController.text,
                  'description': descriptionController.text,
                  'stock': stock,
                  'img': url,
                  'rating': rate
                }).whenComplete(() => snackBar(context, "Plant Updated"));
              } else {
                snackBar(context, "Error");
              }
            },
            child: const Text("Update Plant"),
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
          return "Enter Name";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Plant name",
        hintText: "Enter Name",
      ),
    );
  }

  TextFormField priceFormField() {
    return TextFormField(
      controller: priceController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter price";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Price",
        hintText: "Enter Price",
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
