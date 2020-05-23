import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String appName = "UMkaMu";
final Color backgroundColor = Color(0xFFFFFFFF);
final Color primaryContentColor = Color(0xFF4C4C4C);
final Color secondaryContentColor = Color(0xFFFFFFFF);
final Color primaryColor = Color(0xFFFF3232);
final String primaryFont = 'fonts/Roboto-Light.tff';
final double mediumSize = 20;
final double largeSize = 25;

class SidebarMenuDashboardPage extends StatefulWidget {
  @override
  _SidebarMenuDashboardPageState createState() =>
      _SidebarMenuDashboardPageState();
}

class _SidebarMenuDashboardPageState extends State<SidebarMenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _animationController;
  Animation<double> _dashboardScaleAnimation;
  Animation<double> _sidebarMenuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
    _dashboardScaleAnimation =
        Tween<double>(begin: 1, end: 0.6).animate(_animationController);
    _sidebarMenuScaleAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _sidebarMenuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dashboard',
                  style: TextStyle(
                      color: primaryContentColor,
                      fontSize: mediumSize,
                      fontFamily: primaryFont),
                ),
                SizedBox(height: 10),
                Text(
                  'Messages',
                  style: TextStyle(
                      color: primaryContentColor,
                      fontSize: mediumSize,
                      fontFamily: primaryFont),
                ),
                SizedBox(height: 10),
                Text(
                  'Utilities',
                  style: TextStyle(
                      color: primaryContentColor,
                      fontSize: mediumSize,
                      fontFamily: primaryFont),
                ),
                SizedBox(height: 10),
                Text(
                  'Funds',
                  style: TextStyle(
                      color: primaryContentColor,
                      fontSize: mediumSize,
                      fontFamily: primaryFont),
                ),
                SizedBox(height: 10),
                Text(
                  'Branches',
                  style: TextStyle(
                      color: primaryContentColor,
                      fontSize: mediumSize,
                      fontFamily: primaryFont),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.4 * screenWidth,
      child: ScaleTransition(
        scale: _dashboardScaleAnimation,
        child: Material(
          elevation: 8,
          color: backgroundColor,
          child: Column(
            children: <Widget>[
              Container(
                color: primaryColor,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 40, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    InkWell(
                      child: Icon(Icons.menu, color: secondaryContentColor),
                      onTap: () {
                        setState(() {
                          if (isCollapsed) {
                            _animationController.forward();
                          } else {
                            _animationController.reverse();
                          }
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                    Text(appName,
                        style: TextStyle(
                            color: secondaryContentColor,
                            fontSize: largeSize,
                            fontFamily: primaryFont)),
                    Icon(Icons.settings, color: secondaryContentColor),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                height: 250,
                child: PageView(
                  controller: PageController(viewportFraction: 0.8),
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.amberAccent,
                      width: 100,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.blueAccent,
                      width: 100,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.greenAccent,
                      width: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
