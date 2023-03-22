import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:plant_shop_app/screens/contact_us_screen/contact_us_screen.dart';
import 'package:plant_shop_app/helper/enums.dart';
import 'package:plant_shop_app/screens/profile/components/profile_menu.dart';
import 'package:plant_shop_app/screens/profile/components/profile_pic.dart';
import 'package:plant_shop_app/screens/update_profile/update_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  const ProfileScreen({super.key, required this.user});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () {
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        UpdateProfileForm(user: _currentUser)));
              },
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HelpCentrePage(user: _currentUser)));
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () => {Navigator.pushNamed(context, '/login')},
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
          selectedMenu: MenuState.profile, user: _currentUser),
    );
  }
}
