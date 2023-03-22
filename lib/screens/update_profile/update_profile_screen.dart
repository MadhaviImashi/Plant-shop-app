import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/custom_surfix_icon.dart';
import 'package:plant_shop_app/components/default_button.dart';
import 'package:plant_shop_app/components/form_error.dart';
import 'package:plant_shop_app/screens/profile/profile_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class UpdateProfileForm extends StatefulWidget {
  final User? user;
  const UpdateProfileForm({super.key, required this.user});
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late User _currentUser;
  List<String?> errors = [];
  // final fullNameController = TextEditingController();
  // final emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  String? email;
  String? fullName;
  bool circular = false;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the init method of the SizeConfig class
    SizeConfig().init(context);

    TextFormField buildAddressFormField() {
      return TextFormField(
        onSaved: (newValue) => addressController.text = newValue!,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kAddressNullError);
          }
          return null;
        },
        controller: addressController,
        // focusNode: addressFocusNode,
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kAddressNullError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "Address",
          hintText: "Enter your home address",
          hintStyle: TextStyle(
            color: Colors.grey, // Set the color of the placeholder text
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
        ),
      );
    }

    TextFormField buildPhoneNumberFormField() {
      return TextFormField(
        keyboardType: TextInputType.phone,
        controller: phoneNumberController,
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPhoneNumberNullError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "Phone Number",
          hintText: "Enter your phone number",
          hintStyle: TextStyle(
            color: Colors.grey, // Set the color of the placeholder text
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
        ),
      );
    }

    TextFormField buildEmailFormField() {
      return TextFormField(
        initialValue: email,
        enabled: false,
        // onSaved: (newValue) => email = newValue,
        decoration: const InputDecoration(
          labelText: "Email",
          hintText: "Enter your email address",
          hintStyle: TextStyle(
            color: Colors.grey, // Set the color of the placeholder text
          ),
          filled: true,
          fillColor: Color(0XFFEEEEEE),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      );
    }

    TextFormField buildFullNameFormField() {
      return TextFormField(
        controller: fullNameController,
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kNamelNullError);
            return "";
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "Full Name",
          hintText: "Enter your full name",
          hintStyle: TextStyle(
            color: Colors.grey, // Set the color of the placeholder text
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ProfileScreen(user: _currentUser)));
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text(
                    "My Account",
                    style: TextStyle(
                      color: Color(0xFF58AF8B),
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Form to update your profile details",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('user_data')
                          .doc(_currentUser.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        Map<String, dynamic>? data =
                            snapshot.data?.data() as Map<String, dynamic>?;
                        if (data != null && data.containsKey('email')) {
                          email = data['email'];
                          if (data.containsKey('full_name')) {
                            fullNameController.text = data['full_name'];
                            if (data.containsKey('mobile')) {
                              phoneNumberController.text = data['mobile'];
                              if (data.containsKey('address')) {
                                addressController.text = data['address'];
                              }
                            }
                          } else {
                            List<String>? parts = email?.split('@');
                            String namePart = parts![0];
                            fullName = namePart;
                            // Set the initial value of the email controller to the user's email address
                            fullNameController.text = fullName!;
                          }
                        }
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildFullNameFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildEmailFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildPhoneNumberFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildAddressFormField(),
                              FormError(errors: errors),
                              SizedBox(
                                  height: getProportionateScreenHeight(40)),
                              DefaultButton(
                                text: "Update Profile",
                                press: () async {
                                  if (_formKey.currentState!.validate()) {
                                    errors = [];
                                    setState(() {
                                      circular = true;
                                    });
                                    print(
                                        'updated user details: ${fullNameController.text}, ${phoneNumberController.text}, ${addressController.text}');
                                    DocumentReference<Map<String, dynamic>>
                                        docRef = await FirebaseFirestore
                                            .instance
                                            .collection('user_data')
                                            .doc(_currentUser.uid);

                                    docRef.update({
                                      'full_name': fullNameController.text,
                                      'email': email,
                                      'mobile': phoneNumberController.text,
                                      'address': addressController.text
                                    }).then((value) {
                                      setState(() {
                                        circular = false;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              content: Text(
                                                  'User data updated successfully'),
                                            );
                                          });
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(
                                                      user: _currentUser)));
                                    }).catchError((error) {
                                      setState(() {
                                        circular = false;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              content: Text(
                                                  "Failed to update user data"),
                                            );
                                          });
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: 15),
                  circular ? const CircularProgressIndicator() : const Text(''),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Text(
                    "CTSE-Assignment by team @Falcon",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
