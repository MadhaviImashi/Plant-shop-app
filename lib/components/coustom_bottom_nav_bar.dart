import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_shop_app/screens/cart/cart_screen.dart';
import 'package:plant_shop_app/screens/home/user_home_screen.dart';
import 'package:plant_shop_app/screens/login_success/login_success_screen.dart';
import 'package:plant_shop_app/screens/profile/profile_screen.dart';
import 'package:plant_shop_app/screens/wishlist/wishlist_screen.dart';

import '../helper/constants.dart';
import '../helper/enums.dart';
import 'package:plant_shop_app/screens/cart/components/CartPage.dart';

class CustomBottomNavBar extends StatefulWidget {
  final User? user;
  final MenuState? selectedMenu;

  const CustomBottomNavBar({super.key, required this.selectedMenu, this.user});
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late User _currentUser;
  late MenuState _selectedMenuState;

  @override
  void initState() {
    _currentUser = widget.user!;
    _selectedMenuState = widget.selectedMenu!;
    super.initState();
  }

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({
//     Key? key,
//     required this.selectedMenu,
//   }) : super(key: key);

//   final MenuState selectedMenu;

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
                  color: MenuState.home == _selectedMenuState
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => UserHome(user: _currentUser)))
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Heart Icon.svg",
                  // ignore: deprecated_member_use
                  color: MenuState.favourite == _selectedMenuState
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => WishlistScreen(user: _currentUser)))
                },
              ),
              // IconButton(
              //   icon: SvgPicture.asset(
              //     "assets/icons/Question mark.svg",
              //     // ignore: deprecated_member_use
              //     color: MenuState.tips == _selectedMenuState
              //         ? kPrimaryColor
              //         : inActiveIconColor,
              //   ),
              //   onPressed: () => Navigator.pushNamed(context, '/login'),
              // ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Cart Icon.svg",
                  // ignore: deprecated_member_use
                  color: MenuState.cart == _selectedMenuState
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CartScreen(user: _currentUser)))
                },
              ),
              // IconButton(
              //   icon: SvgPicture.asset(
              //     "assets/icons/Question mark.svg",
              //     // ignore: deprecated_member_use
              //     color: MenuState.tips == _selectedMenuState
              //         ? kPrimaryColor
              //         : inActiveIconColor,
              //   ),
              //   onPressed: () => Navigator.pushNamed(context, '/tips'),
              // ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Question mark.svg",
                  // ignore: deprecated_member_use
                  color: MenuState.tips == _selectedMenuState
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, '/customer_tips'),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  // ignore: deprecated_member_use
                  color: MenuState.profile == _selectedMenuState
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: _currentUser)))
                },
              ),
            ],
          )),
    );
  }
}
