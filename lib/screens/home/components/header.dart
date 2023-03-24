import 'package:flutter/material.dart';
import '../../../helper/constants.dart';

class Header extends StatelessWidget {
  const Header(this.size, {super.key});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12 * 2.5),
      height: 60,
      child: Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: 18,
              ),
              height: size.height * 0.8 - 27,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 54,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
