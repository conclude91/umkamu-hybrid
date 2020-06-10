import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umkamu/ui_view/slider_layout_view.dart';
import 'package:umkamu/utils/theme.dart';

class OnBoarding extends StatefulWidget {
  static const String id = "splashscreen";

  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      );
}
