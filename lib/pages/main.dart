import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
    return MaterialApp(
      title: appName,
      home: DashboardPage(),
    );
  }
}
