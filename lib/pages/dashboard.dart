import 'package:carousel_pro/carousel_pro.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:umkamu/pages/franchise_list.dart';
import 'package:umkamu/pages/user_list.dart';
import 'package:umkamu/utils/theme.dart';

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double _screenWidth, _screenHeight;
  Duration duration = const Duration(milliseconds: 500);
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
    _screenWidth = size.width;
    _screenHeight = size.height;

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
          margin: EdgeInsets.only(right: _screenWidth * 0.25),
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
                                  'Keluar',
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: smallSize,
                                      fontFamily: primaryFont),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {},
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
      left: isCollapsed ? 0 : 0.6 * _screenWidth,
      right: isCollapsed ? 0 : -0.4 * _screenWidth,
      child: ScaleTransition(
        scale: _dashboardScaleAnimation,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            centerTitle: true,
            elevation: 0,
            title: Image(
              color: primaryColor,
              image: AssetImage('assets/images/umkamu.png'),
              height: 20,
            ),
            leading: IconButton(
              icon: Icon(Icons.menu, color: primaryContentColor),
              onPressed: () {
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
            bottom: PreferredSize(
              child: Container(
                color: shadow,
                height: 1,
              ),
              preferredSize: Size.fromHeight(4.0),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 50),
            shrinkWrap: true,
            children: [
/*
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
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
                      color: primaryColor,
                      image: AssetImage('assets/images/umkamu.png'),
                      height: 20,
                    ),
                    InkWell(
                      child: Icon(Icons.settings, color: primaryContentColor),
                      onTap: () {
                        */
/*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WhatsAppPage()));*/ /*

                      },
                    ),
                  ],
                ),
              ),
*/
              SizedBox(
                height: 200,
                width: _screenWidth,
                child: Carousel(
                  images: [
                    NetworkImage(
                        'https://non-indonesia-distribution.brta.in/2019-01/36c49e263ba2607cf4ff29c9b7739075bf595128.jpg'),
                    NetworkImage(
                        'https://balitribune.co.id/sites/default/files/styles/xtra_large/public/field/image/Orang%20Eropa%20Doyan%20Makanan%20Indonesia.jpg?itok=KhyFFbAs'),
                    NetworkImage(
                        'https://blog.cakap.com/wp-content/uploads/2019/03/food-feature.jpg'),
                    //ExactAssetImage("assets/images/LaunchImage.jpg")
                  ],
                  dotSize: 3.0,
                  dotSpacing: 15.0,
                  dotColor: secondaryContentColor,
                  indicatorBgPadding: 5.0,
                  dotBgColor: transparent,
                  borderRadius: true,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: _screenWidth,
                height: 110,
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        /*onTap: () {
                          Navigator.of(context)
                              .pushNamed(MyHomePage.id);
                        },*/
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/images/poin.png'),
                                height: 40,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Poin',
                                style: TextStyle(
                                    color: primaryContentColor,
                                    fontSize: tinySize,
                                    fontFamily: primaryFont),
                              ),
                              Text(
                                '20.000',
                                style: TextStyle(
                                    color: primaryContentColor,
                                    fontSize: tinySize,
                                    fontFamily: primaryFont),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        /*onTap: () {
                          Navigator.of(context)
                              .pushNamed(UserList.id);
                        },*/
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/images/komisi.png'),
                                height: 40,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Komisi',
                                style: TextStyle(
                                    color: primaryContentColor,
                                    fontSize: tinySize,
                                    fontFamily: primaryFont),
                              ),
                              Text(
                                '5.000.000',
                                style: TextStyle(
                                    color: primaryContentColor,
                                    fontSize: tinySize,
                                    fontFamily: primaryFont),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed(FranchiseList.id),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Image(
                                image: AssetImage('assets/images/royalty.png'),
                                height: 40,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Royalty',
                                style: TextStyle(
                                    color: primaryContentColor,
                                    fontSize: tinySize,
                                    fontFamily: primaryFont),
                              ),
                              Text(
                                '2.000.000',
                                style: TextStyle(
                                    color: primaryContentColor,
                                    fontSize: tinySize,
                                    fontFamily: primaryFont),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: shadow,
                ),
              ),
              Container(
                width: _screenWidth,
                height: 200,
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              /*onTap: () {
                                Navigator.of(context)
                                    .pushNamed(MyHomePage.id);
                              },*/
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/kantor.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Kantor',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              /*onTap: () {
                                Navigator.of(context)
                                    .pushNamed(UserList.id);
                              },*/
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/cabang.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Cabang',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(FranchiseList.id),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/jajanan.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Jajanan',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(FranchiseList.id),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image:
                                          AssetImage('assets/images/oleh.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Oleh-Oleh',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(FranchiseList.id),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/antaran.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Antaran',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed(UserList.id),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/leader.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Leader',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/profit.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Profit',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                        'assets/images/supplier.png'),
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Supplier',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: tinySize,
                                        fontFamily: primaryFont),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => FlutterOpenWhatsapp.sendSingleMessage(
                                  "+6285721606950",
                                  "Hallo saya tertarik ingin melakukan pengajuan pemodalan, akan saya lampirkan fotocopy KTP, PBB, Tagihan Listrik, Rekening Koran, "
                                      "Slip Gaji, Surat Permohonan Pembiayaan dan Quotation."
                                      "Jika berkenan tolong balas pesan ini, terimakasih."),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image:
                                          AssetImage('assets/images/modal.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Modal',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () =>
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                      "+6281297947569",
                                      "Hallo saya ingin bertanya..."),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image:
                                          AssetImage('assets/images/tanya.png'),
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Tanya',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: primaryColor,
            backgroundColor: backgroundColor,
            buttonBackgroundColor: primaryColor,
            height: 50,
            animationDuration: Duration(milliseconds: 500),
            animationCurve: Curves.fastOutSlowIn,
            items: [
              Icon(Icons.thumb_up,
                  size: mediumSize, color: secondaryContentColor),
              Icon(Icons.library_books,
                  size: mediumSize, color: secondaryContentColor),
              Icon(Icons.shopping_cart,
                  size: mediumSize, color: secondaryContentColor),
              Icon(Icons.notifications_active,
                  size: mediumSize, color: secondaryContentColor),
              Icon(Icons.account_circle,
                  size: mediumSize, color: secondaryContentColor),
            ],
            onTap: (index) {
              debugPrint('this is index-$index');
            },
          ),
        ),
      ),
    );
  }
}
