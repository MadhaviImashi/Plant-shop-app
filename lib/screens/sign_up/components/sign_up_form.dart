import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/custom_surfix_icon.dart';
import 'package:plant_shop_app/components/default_button.dart';
import 'package:plant_shop_app/components/form_error.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkController = TextEditingController();
  final List<String?> errors = [];
  bool circular = false;

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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Sign Up",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  circular = true;
                });
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                  print('user created');
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/login');
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    circular = false;
                  });
                  if (e.code == 'weak-password') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Text('Weak password'),
                          );
                        });
                  } else if (e.code == 'email-already-in-use') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Text(
                                'An acccount already exists for this email!'),
                          );
                        });
                  }
                }
              }
            },
          ),
          SizedBox(height: 20),
          circular ? const CircularProgressIndicator() : const Text(''),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      controller: checkController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((passwordController.text != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 4) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      // onSaved: (newValue) => email = newValue,
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
