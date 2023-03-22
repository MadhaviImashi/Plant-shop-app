import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/custom_surfix_icon.dart';
import 'package:plant_shop_app/components/default_button.dart';
import 'package:plant_shop_app/components/form_error.dart';
import 'package:plant_shop_app/components/socal_card.dart';
import 'package:plant_shop_app/size_config.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final checkController = TextEditingController();
  List<String?> errors = [];
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getRelativeScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Text(
                    "Welcome! ☘️",
                    style: TextStyle(
                      color: Color(0xFF6edbae),
                      fontSize: getRelativeScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        emailFormField(),
                        SizedBox(height: getRelativeScreenHeight(30)),
                        passwordFormField(),
                        SizedBox(height: getRelativeScreenHeight(30)),
                        conformPassFormField(),
                        FormError(errors: errors),
                        SizedBox(height: getRelativeScreenHeight(40)),
                        DefaultButton(
                          text: "Sign Up",
                          press: () async {
                            User? user;
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              errors = [];
                              setState(() {
                                circular = true;
                              });
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);
                                user = userCredential.user;
                                print('user created ${user}');
                                // save the email of the user in user_data collection
                                DocumentReference<Map<String, dynamic>> docRef =
                                    await FirebaseFirestore.instance
                                        .collection('user_data')
                                        .doc(user?.uid);

                                await docRef.set({
                                  'email': user?.email,
                                });
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
                        circular
                            ? const CircularProgressIndicator()
                            : const Text(''),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/twitter.svg",
                        press: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: getRelativeScreenHeight(20)),
                  Text(
                    'CTSE-Assignment by team @Falcon',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailFormField() {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      // onSaved: (newValue) => email = newValue,
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: 'Please Enter your email');
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: 'Please Enter Valid Email');
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

  TextFormField passwordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Please Enter your password");
          return "";
        } else if (value.length < 4) {
          addError(error: 'Password is too short');
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

  TextFormField conformPassFormField() {
    return TextFormField(
      obscureText: true,
      controller: checkController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: 'Please Enter your password');
          return "";
        } else if ((passwordController.text != value)) {
          addError(error: "Passwords don't match");
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
}
