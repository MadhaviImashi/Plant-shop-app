import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/custom_surfix_icon.dart';
import 'package:plant_shop_app/components/form_error.dart';
import 'package:plant_shop_app/helper/keyboard.dart';
import 'package:plant_shop_app/screens/login_success/login_success_screen.dart';
import 'package:plant_shop_app/screens/profile/profile_screen.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Login",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
                // if all are valid then go to Profile page
                signIn(emailController.text, passwordController.text)
                    .then((value) => {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) =>
                                  LoginSuccessScreen() // this should be replaced with Home(user: value))
                              ))
                        })
                    .catchError((err) => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: Text('Login failed'),
                                );
                              })
                        });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

Future<User?> signIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      // if (kDebugMode) {
      //   print('No user found for this email.');
      // }
      print('No user found for this email.');
      return null;
    } else if (e.code == 'wrong-password') {
      // if (kDebugMode) {
      //   print('Invalid password.');
      // }
      print('Invalid password.');
      return null;
    }
  }
  return user;
}
