import 'package:flutter/material.dart';

import 'components/body.dart';

class UpdateProfileScreen extends StatelessWidget {
  static String routeName = "/update_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Update profile'),
          ),
      body: Body(),
    );
  }
}
