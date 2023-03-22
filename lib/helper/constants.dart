import 'package:flutter/material.dart';
import 'package:plant_shop_app/helper/size_config.dart';

const kPrimaryColor = Color(0xFF58AF8B);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF6edbae), Color(0xFF58AF8B)],
);
const kSecondaryColor = Color(0xFF6edbae);
const kTextColor = Color.fromARGB(255, 47, 47, 47);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getRelativeScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getRelativeScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
