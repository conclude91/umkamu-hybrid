import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:umkamu/pages/whatsapp.dart';
import 'package:umkamu/utils/theme.dart';

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 500);
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
        children: [
          navDrawer(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget navDrawer(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _sidebarMenuScaleAnimation,
        child: Container(
          margin: EdgeInsets.only(right: screenWidth * 0.25),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: FractionalOffset.topCenter,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/food.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.jpg'),
                        radius: 50,
                      ),
                    ),
                    Divider(
                      thickness: 0.25,
                      color: primaryContentColor,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.dashboard,
                                      size: smallSize,
                                      color: primaryContentColor),
                                  SizedBox(
                                    width: smallSize,
                                  ),
                                  Text(
                                    'Dashboard',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: smallSize,
                                        fontFamily: primaryFont),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.message,
                                      size: smallSize,
                                      color: primaryContentColor),
                                  SizedBox(
                                    width: smallSize,
                                  ),
                                  Text(
                                    'Messages',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: smallSize,
                                        fontFamily: primaryFont),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.security,
                                      size: smallSize,
                                      color: primaryContentColor),
                                  SizedBox(
                                    width: smallSize,
                                  ),
                                  Text(
                                    'Utilities',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: smallSize,
                                        fontFamily: primaryFont),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.attach_money,
                                      size: smallSize,
                                      color: primaryContentColor),
                                  SizedBox(
                                    width: smallSize,
                                  ),
                                  Text(
                                    'Funds',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: smallSize,
                                        fontFamily: primaryFont),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.home,
                                      size: smallSize,
                                      color: primaryContentColor),
                                  SizedBox(
                                    width: smallSize,
                                  ),
                                  Text(
                                    'Branches',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: smallSize,
                                        fontFamily: primaryFont),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.settings,
                                    size: smallSize,
                                    color: primaryContentColor),
                                SizedBox(
                                  width: smallSize,
                                ),
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: smallSize,
                                      fontFamily: primaryFont),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.exit_to_app,
                                    size: smallSize,
                                    color: primaryContentColor),
                                SizedBox(
                                  width: smallSize,
                                ),
                                Text(
                                  'Exit',
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: smallSize,
                                      fontFamily: primaryFont),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
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
          child: ClipRRect(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 40, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          child: Icon(Icons.menu, color: primaryContentColor),
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
                        Image(
                          image: AssetImage('assets/images/umkamu.png'),
                          height: 20,
                        ),
                        InkWell(
                          child:
                              Icon(Icons.settings, color: primaryContentColor),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WhatsAppPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    height: 175,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.925),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox.expand(
                              child: Image.asset("assets/mudik.jpeg",
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox.expand(
                              child: Image.asset("assets/clbk.jpeg",
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox.expand(
                              child: Image.asset("assets/normal.jpeg",
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: CurvedNavigationBar(
                color: primaryColor,
                backgroundColor: secondaryContentColor,
                buttonBackgroundColor: primaryColor,
                height: 50,
                animationDuration: Duration(milliseconds: 500),
                animationCurve: Curves.fastOutSlowIn,
                items: [
                  Icon(Icons.add,
                      size: mediumSize, color: secondaryContentColor),
                  Icon(Icons.list,
                      size: mediumSize, color: secondaryContentColor),
                  Icon(Icons.compare_arrows,
                      size: mediumSize, color: secondaryContentColor),
                  Icon(Icons.verified_user,
                      size: mediumSize, color: secondaryContentColor),
                  Icon(Icons.add_a_photo,
                      size: mediumSize, color: secondaryContentColor),
                ],
                onTap: (index) {
                  debugPrint('this is index-$index');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
