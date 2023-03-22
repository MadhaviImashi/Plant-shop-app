import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:plant_shop_app/screens/plants/admin_view.dart';
import 'package:plant_shop_app/screens/plants/camera_image.dart';
import 'package:plant_shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:plant_shop_app/screens/sign_up/sign_up_screen.dart';
import 'package:plant_shop_app/theme.dart';
import 'firebase_options.dart';
import 'package:plant_shop_app/screens/cart/components/CartPage.dart';

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
        // '/home': (BuildContext context) => const UserHome(user: null),
        // '/favorites': (BuildContext context) =>
        //     const WishlistScreen(user: null),
        '/cart': (BuildContext context) => CartPage(),
        '/tips': (BuildContext context) => SignInScreen(),
        // '/profile': (BuildContext context) => const ProfileScreen(user: null),
        // '/profile-update': (BuildContext context) => UpdateProfileScreen(),
        '/admin_home': (BuildContext context) => const AdminHome(),
        '/add_plant': (BuildContext context) => const AddImage(),
      },
    );
  }
}
