import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:intl/intl.dart';
import 'package:plant_shop_app/enums.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/enums.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import '../../../components/default_button.dart';
import '../../../size_config.dart';
import '../../../constants.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _address;
  late String _phoneNumber;

  void _showEditDialog(BuildContext context, DocumentSnapshot document) {
    _email = document['email'];
    _address = document['address'];
    _phoneNumber = document['phoneNumber'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Order"),
          content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _address,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _address = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _phoneNumber,
                      decoration: InputDecoration(labelText: 'Telephone'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter telephone';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _phoneNumber = value!;
                      },
                    ),
                  ],
                ),
              )),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(document.id)
                      .update({
                    'email': _email,
                    'address': _address,
                    'telephone': _phoneNumber,
                  });

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Order'),
          content: Text('Are you sure you want to delete this order?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
              ),
              child: Text('Delete'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(document.id)
                    .delete();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data!.docs[index];
                  var data = document.data() as Map<String, dynamic>;
                  return ListTile(
                      tileColor: Color.fromARGB(255, 182, 235, 212),
                      title: Text(data['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${data['email']}'),
                          Text('Telephone: ${data['phone_number']}'),
                          Text('Address: ${data['address']}'),
                          Text(
                              'Items: ${data['item_name'] != null ? data['item_name'].join(', ') : ''}'),
                          Text('Total Price: ${data['total_price']}'),
                          Text(
                            '------------------------------------------------',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                      trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteDialog(context, document);
                              },
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 238, 250, 246),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Update Order'),
                                          content: SingleChildScrollView(
                                              // Wrap content with SingleChildScrollView
                                              child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  initialValue: data['email'],
                                                  decoration: InputDecoration(
                                                      labelText: 'Email'),
                                                  onChanged: (value) =>
                                                      data['email'] = value,
                                                ),
                                                SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            10)),
                                                TextFormField(
                                                  initialValue:
                                                      data['phone_number'],
                                                  decoration: InputDecoration(
                                                      labelText: 'Telephone'),
                                                  onChanged: (value) =>
                                                      data['phone_number'] =
                                                          value,
                                                ),
                                                SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            10)),
                                                TextFormField(
                                                  initialValue: data['address'],
                                                  decoration: InputDecoration(
                                                      labelText: 'Address'),
                                                  onChanged: (value) =>
                                                      data['address'] = value,
                                                ),
                                              ],
                                            ),
                                          )),
                                          actions: [
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            DefaultButton(
                                              text: "Cancel",
                                              press: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            DefaultButton(
                                              text: "Update",
                                              press: () {
                                                // Perform update operation on data map
                                                FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .update(data);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ))
                          ]));
                },
              );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
