import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/default_button.dart';
import 'package:plant_shop_app/screens/home/user_home_screen.dart';
import 'package:plant_shop_app/helper/size_config.dart';

class LoginSuccessScreen extends StatefulWidget {
  final User? user;
  const LoginSuccessScreen({super.key, required this.user});
  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // const SizedBox(height: 0),
          Center(
            child: Image.asset(
              "assets/images/success.jpg",
              height: SizeConfig.screenHeight * 0.6, //40%
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            "Login Successfull !",
            style: TextStyle(
              fontSize: getRelativeScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 108, 107, 107),
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "Continue",
              press: () {
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => UserHome(user: _currentUser)));
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
