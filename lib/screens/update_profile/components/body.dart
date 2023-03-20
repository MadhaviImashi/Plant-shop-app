import 'package:flutter/material.dart';
import 'package:plant_shop_app/constants.dart';
import 'package:plant_shop_app/size_config.dart';

import 'update_profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call the init method of the SizeConfig class
    SizeConfig().init(context);

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text(
                  "My Account",
                  style: TextStyle(
                    color: Color.fromARGB(255, 8, 182, 52),
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Form to update your profile details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                UpdateProfileForm(),
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
    );
  }
}
