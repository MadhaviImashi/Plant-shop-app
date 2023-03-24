import 'package:flutter/material.dart';
import '../../components/admin_nav.dart';
import '../../helper/admin_enum.dart';
import 'components/update_form.dart';

///Update plant data
class UpdatePlants extends StatefulWidget {
  final String id;
  final String url;
  final String name;
  final String type;
  final String description;
  final String price;
  final int rate;
  final String stock;

  const UpdatePlants(
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
  State<UpdatePlants> createState() => _UpdatePlantsState();
}

class _UpdatePlantsState extends State<UpdatePlants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Plant"),
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
                  price: widget.price,
                  rate: widget.rate,
                  stock: widget.stock,
                  description: widget.description))
        ])),
        bottomNavigationBar:
            const AdminNavBar(selectedMenu: AdminState.plants));
  }
}
