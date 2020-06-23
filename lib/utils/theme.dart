import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final String appName = "UMkaMu";
final Color backgroundColor = Color(0xFFFCFFFD);
final Color primaryContentColor = Color(0xFF0C1821);
final Color primaryLightContentColor = Color(0xFF9E9E9E);
final Color secondaryContentColor = Color(0xFFFCFFFD);
final Color primaryColor = Color(0xFFFC5C65);
final Color secondaryColor = Color(0xFF03A9F4);
final Color accentColor = Color(0xFF66bb6a);
final Color transparent = Colors.transparent;
final Color shadow = Color(0xFFECECEC);
final String primaryFont = 'Roboto';
final FontWeight fontBold = FontWeight.w900;
final double tinySize = 15;
final double smallSize = 17;
final double mediumSize = 20;
final double largeSize = 25;

void setStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color));
}
