import 'package:flutter/material.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/register.dart';
import 'package:umkamu/pages/splashscreen.dart';
import 'package:umkamu/utils/theme.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setStatusBarColor(primaryColor);
    return MaterialApp(
      title: appName,
      home: Login(
        backgroundColor1: backgroundColor,
        backgroundColor2: backgroundColor,
        highlightColor: primaryColor,
        foregroundColor: primaryContentColor,
        logo: AssetImage("assets/images/logo.png"),
      ),
      /*Register(
        backgroundColor1: backgroundColor,
        backgroundColor2: backgroundColor,
        highlightColor: primaryColor,
        foregroundColor: primaryContentColor,
        logo: AssetImage("assets/images/logo.png"),
      ),*/
      //initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Dashboard.id: (context) => Dashboard(),
//        OnBoarding.id: (context) => OnBoarding(),
      },
    );
  }
}
