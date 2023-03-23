import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_shop_app/helper/constants.dart';
import 'package:plant_shop_app/helper/enums.dart';
import 'package:plant_shop_app/helper/size_config.dart';
import 'OrdersPage.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import '../../../components/default_button.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
  final double totalPrice;
  List<String> itemName = [];
  CheckoutPage({required this.totalPrice, required this.itemName});
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _address = "";
  String _phoneNumber = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash on Delivery Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                    children: [
                      WidgetSpan(
                          child: Divider(
                        height: 10,
                        thickness: 4,
                        color: kPrimaryColor,
                      )),
                      TextSpan(
                        text: 'Items Ordered:  ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${widget.itemName.join(", ")}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: 'Total Price:  ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${widget.totalPrice}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      WidgetSpan(
                          child: Divider(
                        height: 10,
                        thickness: 4,
                        color: Color.fromARGB(255, 119, 152, 124),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: getRelativeScreenHeight(30)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter delivery name",
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: getRelativeScreenHeight(8)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter delivery address",
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _address = value!;
                  },
                ),
                SizedBox(height: getRelativeScreenHeight(8)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter delivery phone number",
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneNumber = value!;
                  },
                ),
                SizedBox(height: getRelativeScreenHeight(8)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: "Enter delivery email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                SizedBox(height: 16.0),
                SizedBox(height: getRelativeScreenHeight(5)),
                DefaultButton(
                  text: "Submit Order",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FirebaseFirestore.instance.collection("orders").add({
                        "name": _name,
                        "address": _address,
                        "phone_number": _phoneNumber,
                        "email": _email,
                        "item_name": widget.itemName,
                        "total_price": widget.totalPrice,
                        "created_at": DateTime.now(),
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Order placed successfully")),
                        );

                        _formKey.currentState!.reset();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to place order")),
                        );
                      });
                    }
                  },
                ),
                SizedBox(height: getRelativeScreenHeight(10)),
                DefaultButton(
                  text: "View Orders",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrdersPage()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
