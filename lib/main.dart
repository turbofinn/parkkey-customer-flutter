import 'package:flutter/material.dart';
import 'package:parkey_customer/Fragment/ProfileFragment.dart';
import 'package:parkey_customer/Fragment/add_vehicle_fragment.dart';
import 'package:parkey_customer/Fragment/dedicated_history_fragment.dart';
import 'package:parkey_customer/Fragment/history_fragment.dart';
import 'package:parkey_customer/screens/home_screen.dart';
import 'package:parkey_customer/screens/login_screen.dart';
import 'package:parkey_customer/screens/my_qr_screen.dart';
import 'package:parkey_customer/screens/payment_screen.dart';
import 'package:parkey_customer/screens/post_login_screen.dart';
import 'package:parkey_customer/screens/splash_screen.dart';
import 'Fragment/parked_vehicles_fragment.dart';
import 'HomeFragment.dart' hide Widget;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
