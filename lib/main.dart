import 'package:flutter/material.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/onboarding.dart';
import 'package:umkamu/pages/splashscreen.dart';
import 'package:umkamu/utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setStatusBarColor(primaryColor);
    return MaterialApp(
      title: appName,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Dashboard.id: (context) => Dashboard(),
        OnBoarding.id: (context) => OnBoarding(),
      },
    );
  }
}
