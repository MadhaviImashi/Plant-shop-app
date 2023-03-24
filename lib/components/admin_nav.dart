import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helper/admin_enum.dart';
import '../helper/constants.dart';

class AdminNavBar extends StatelessWidget {
  const AdminNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final AdminState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color.fromARGB(255, 97, 158, 112).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  // ignore: deprecated_member_use
                  color: AdminState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, '/admin_home'),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Question mark.svg",
                  // ignore: deprecated_member_use
                  color: AdminState.tips == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, '/tips'),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Star Icon.svg",
                  // ignore: deprecated_member_use
                  color: AdminState.plants == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, '/add_plant'),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Search Icon.svg",
                  // ignore: deprecated_member_use
                  color: AdminState.tips == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, '/view_tips'),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Log out.svg",
                  // ignore: deprecated_member_use
                  color: AdminState.tips == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
            ],
          )),
    );
  }
}
