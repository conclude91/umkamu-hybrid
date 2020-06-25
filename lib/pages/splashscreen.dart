import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:umkamu/pages/onboarding.dart';
import 'package:umkamu/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  authenticate() async {
    return _timer = Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(OnBoarding.id);
    });
  }

  @override
  void initState() {
    super.initState();
    authenticate();
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
              "umkamu @ 2020",
              style: TextStyle(
                color: primaryContentColor,
                fontSize: tinySize,
                fontFamily: primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
