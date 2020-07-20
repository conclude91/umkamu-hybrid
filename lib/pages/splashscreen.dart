import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/onboarding.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  _authenticate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return _timer = Timer(Duration(seconds: 5), () {
      if (sharedPreferences.getBool('isLogin') ?? false) {
        Navigator.of(context).pushReplacementNamed(Dashboard.id);
      } else {
        Navigator.of(context).pushReplacementNamed(OnBoarding.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
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
      body: Stack(
        children: <Widget>[
          Container(
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
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
            alignment: Alignment.bottomCenter,
            child: Text(
              copyright,
              style: TextStyle(
                color: primaryContentColor,
                fontSize: microSize,
                fontFamily: primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
