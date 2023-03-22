import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/custom_surfix_icon.dart';
import 'package:plant_shop_app/components/form_error.dart';
import 'package:plant_shop_app/components/no_account_text.dart';
import 'package:plant_shop_app/components/socal_card.dart';
import 'package:plant_shop_app/helper/keyboard.dart';
import 'package:plant_shop_app/screens/login_success/login_success_screen.dart';

import '../../../components/default_button.dart';
import '../../../helper/size_config.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
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
                        FormError(errors: errors),
                        SizedBox(height: getRelativeScreenHeight(20)),
                        DefaultButton(
                          text: "Login",
                          press: () async {
                            User? user;
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);
                              errors = [];
                              setState(() {
                                circular = true;
                              });
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                user = userCredential.user;
                                print('user credencials ${user}');
                                setState(() {
                                  circular = false;
                                });
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LoginSuccessScreen(
                                            user:
                                                user) // this should be replaced with Home(user: value))
                                        ));
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  circular = false;
                                });
                                if (e.code == 'user-not-found') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          content: Text(
                                              'No user found for this email.'),
                                        );
                                      });
                                } else if (e.code == 'wrong-password') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          content: Text('Invalid password.'),
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
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: 'Please Enter your password');
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

  TextFormField emailFormField() {
    final RegExp emailValidatorRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return TextFormField(
      keyboardType: TextInputType.emailAddress,
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
}
