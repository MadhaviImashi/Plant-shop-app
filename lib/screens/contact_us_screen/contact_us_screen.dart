import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_shop_app/helper/constants.dart';
import 'package:plant_shop_app/screens/profile/profile_screen.dart';
import 'package:plant_shop_app/helper/size_config.dart';

class HelpCentrePage extends StatefulWidget {
  final User? user;
  const HelpCentrePage({super.key, required this.user});
  @override
  _HelpCentrePageState createState() => _HelpCentrePageState();
}

class _HelpCentrePageState extends State<HelpCentrePage> {
  late User _currentUser;
  String? _userName;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
    _getUserName();
  }

  void _getUserName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user_data')
          .doc(_currentUser.uid)
          .get();
      setState(() {
        _userName = userSnapshot.get('full_name');
      });
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Help Center"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ProfileScreen(user: _currentUser)));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getRelativeScreenWidth(26)),
        child: Container(
          child: Center(
            child: LimitedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  const Text(
                    'Call Us',
                    style: TextStyle(
                      color: Color(0xFF58AF8B),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Color(0xFF58AF8B),
                      ),
                      const SizedBox(width: 7.0),
                      const Text(
                        '123-456-7890',
                        style: TextStyle(
                          color: Color.fromARGB(255, 97, 96, 96),
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 7.0),
                      GestureDetector(
                        onTap: () {
                          // Implement call functionality here
                        },
                        child: const Icon(
                          Icons.call,
                          color: Color(0xFF58AF8B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  const Text(
                    'About Us',
                    style: TextStyle(
                      color: Color(0xFF58AF8B),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    color: Color.fromARGB(255, 229, 246, 241),
                    child: const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color.fromARGB(255, 97, 96, 96),
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
