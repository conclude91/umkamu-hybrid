import 'dart:async';

import 'package:flutter/material.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/onboarding.dart';
import 'package:umkamu/ui_view/slider_layout_view.dart';
import 'package:umkamu/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  removeScreen() {
    return _timer = Timer(Duration(seconds: 5), () {
//      Navigator.of(context).pushReplacementNamed(Dashboard.id);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoarding()));
    });
  }

  @override
  void initState() {
    super.initState();
    removeScreen();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        child: Center(
          child: Image(
            width: 100,
            color: primaryColor,
            image: AssetImage(
              "assets/images/logo.png",
            ),
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/doodle-potrait.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
