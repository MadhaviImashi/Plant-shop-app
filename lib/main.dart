import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:plant_shop_app/screens/profile/profile_screen.dart';
import 'package:plant_shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:plant_shop_app/screens/sign_up/sign_up_screen.dart';
import 'package:plant_shop_app/screens/update_profile/update_profile_screen.dart';
import 'package:plant_shop_app/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 167, 211, 193), // set status bar color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      home: SignInScreen(),
      routes: {
        '/login': (BuildContext context) => SignInScreen(),
        '/register': (BuildContext context) => SignUpScreen(),
        '/home': (BuildContext context) => SignInScreen(),
        '/favorites': (BuildContext context) => SignInScreen(),
        '/cart': (BuildContext context) => SignInScreen(),
        '/tips': (BuildContext context) => SignInScreen(),
        '/profile': (BuildContext context) => const ProfileScreen(),
        '/profile-update': (BuildContext context) => UpdateProfileScreen(),
      },
    );
  }
}
