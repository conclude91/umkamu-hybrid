import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umkamu/pages/login.dart';
import 'package:umkamu/utils/theme.dart';

class OnBoarding extends StatefulWidget {
  static const String id = "onboarding";

  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  _initPage() {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return sliderLayout();
  }

  Widget sliderLayout() => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/doodle-potrait.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: sliderArrayList.length,
                    itemBuilder: (ctx, i) => SlideItem(i),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Login.id);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 15.0, bottom: 15.0, top: 15, left: 15),
                            child: Text(
                              "Lewati",
                              style: TextStyle(
                                fontFamily: primaryFont,
                                fontSize: tinySize,
                                color: primaryContentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.bottomCenter,
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < sliderArrayList.length; i++)
                              if (i == _currentPage)
                                SlideDots(true)
                              else
                                SlideDots(false)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      );
}

class SlideItem extends StatelessWidget {
  final int _index;

  SlideItem(this._index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(sliderArrayList[_index].imageUrl),
            ),
          ),
        ),
        SizedBox(
          height: 60.0,
        ),
        Text(
          sliderArrayList[_index].heading,
          style: TextStyle(
            fontFamily: primaryFont,
            fontWeight: fontBold,
            fontSize: mediumSize,
            color: primaryContentColor,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[_index].subHeading,
              style: TextStyle(
                fontFamily: primaryFont,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: microSize,
                color: primaryContentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}

class SlideDots extends StatelessWidget {
  bool _isActive;

  SlideDots(this._isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: _isActive ? 10 : 6,
      width: _isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: _isActive ? primaryColor : primaryContentColor,
        border: _isActive
            ? Border.all(
                color: secondaryContentColor,
                width: 1.0,
              )
            : Border.all(
                color: secondaryContentColor,
                width: 1,
              ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Slider {
  final String imageUrl;
  final String heading;
  final String subHeading;

  Slider(
      {@required this.imageUrl,
      @required this.heading,
      @required this.subHeading});
}

final sliderArrayList = [
  Slider(
      imageUrl: 'assets/images/slider_1.png',
      heading: "Easy Exchange ! ",
      subHeading: appName +
          " memudahkan kamu untuk mendapatkan poin, komisi dan royalty dari konten yang kamu sebarkan."),
  Slider(
      imageUrl: 'assets/images/slider_2.png',
      heading: "Easy to Use !",
      subHeading: appName +
          " mudah digunakan lho !\nTampilannya mudah dimengerti dan pastinya bikin kamu nyaman menggunakannya"),
  Slider(
      imageUrl: 'assets/images/slider_3.png',
      heading: "Connect With Others !",
      subHeading: "Tunggu apa lagi ?\nAyo bergabung dengan " +
          appName +
          " untuk perluas jaringanmu dan dapatkan keuntunganmu sendiri."),
];
