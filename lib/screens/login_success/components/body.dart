import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/default_button.dart';
import 'package:plant_shop_app/screens/home/home_screen.dart';
import 'package:plant_shop_app/screens/login_success/login_success_screen.dart';
import 'package:plant_shop_app/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            fontSize: getProportionateScreenWidth(30),
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
              Navigator.pushNamed(context, LoginSuccessScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
