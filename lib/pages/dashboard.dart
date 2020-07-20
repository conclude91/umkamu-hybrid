import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/pages/empty_list.dart';
import 'package:umkamu/pages/franchise_list.dart';
import 'package:umkamu/pages/splashscreen.dart';
import 'package:umkamu/pages/supplier.dart';
import 'package:umkamu/pages/user_form.dart';
import 'package:umkamu/pages/user_list.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/theme.dart';

import 'ask.dart';
import 'franchise_detail.dart';
import 'franchise_form.dart';
import 'office.dart';

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  List<User> _listUser;
  List<Franchise> _listFranchise;
  List<Franchise> _myFranchise;
  List<InkWell> _listImagePromo = List<InkWell>();
  bool isCollapsed = true;
  Duration duration = const Duration(milliseconds: 500);
  AnimationController _animationController;
  Animation<double> _dashboardScaleAnimation;
  Animation<double> _sidebarMenuScaleAnimation;
  Animation<Offset> _slideAnimation;
  bool _isLogin;
  String _id;
  String _access;

  @override
  void initState() {
    super.initState();
    _getPreferences();
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

  _showConfirmationAlert(BuildContext context, String msg) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Ada yang bisa dibantu ?",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          msg + '\n\n* Pesan ini akan diteruskan ke admin.',
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: tinySize,
              color: primaryContentColor),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Batalkan"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Teruskan"),
            onPressed: () {
              FlutterOpenWhatsapp.sendSingleMessage(adminContact, msg);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _removePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String key in prefs.getKeys()) {
      prefs.remove(key);
    }
  }

  _getIdentityMessage() {
    return '\n\nBerikut data diri saya :\n\nNama : ' +
        _listUser[0].nama +
        '\nID : ' +
        _listUser[0].id +
        '\nRekening : ' +
        _listUser[0].rekening;
  }

  _showConfirmationRedeem(BuildContext context, String title, String msg) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          title,
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          msg,
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: tinySize,
              color: primaryContentColor),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Batalkan"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Ajukan"),
            onPressed: () {
              FlutterOpenWhatsapp.sendSingleMessage(
                  adminContact, 'Hai Admin,\n\n' + msg + _getIdentityMessage());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _showConfirmationLogout(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Ingin keluar dari sistem ?",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          "Proses ini akan mereset data lokal di device.\n"
          "Jika ingin tersambung kembali dengan jaringan kami, lakukan ulang proses login sistem.",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: tinySize,
              color: primaryContentColor),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Batalkan"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Keluar"),
            onPressed: () {
              _removePreferences();
              imageCache.clear();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(SplashScreen.id);
            },
          ),
        ],
      ),
    );
  }

  _showConfirmationPoinRedeem(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Mau mencairkan dana poin ? ?",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          "Pencairan dana poin hanya bisa dilakukan pada nominal 5000, 10000 dan 15000.\n",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: tinySize,
              color: primaryContentColor),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Tutup"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogin = prefs.getBool('isLogin') ?? false;
      _id = prefs.getString('id') ?? '';
      _access = prefs.getString('access') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<User>>(context) != null) {
      _listUser = Provider.of<List<User>>(context)
          .where((user) => user.id == _id)
          .toList();
    }
    if (Provider.of<List<Franchise>>(context) != null) {
      _listFranchise = Provider.of<List<Franchise>>(context)
          .where((franchise) => franchise.promo == 'Ya')
          .toList();
      _myFranchise = Provider.of<List<Franchise>>(context)
          .where((franchise) => franchise.id == _listUser[0].id)
          .toList();
    }
    if (_listFranchise != null) {
      if (_listImagePromo.length != _listFranchise.length) {
        _listImagePromo.clear();
        for (int i = 0; i < _listFranchise.length; i++) {
          _listImagePromo.add(
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(FranchiseDetail.id, arguments: _listFranchise[i]),
              child: CachedNetworkImage(
                imageUrl: _listFranchise[i].foto1,
              ),
            ),
          );
        }
      }
    }
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
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.25),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: FractionalOffset.topCenter,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/doodle-potrait.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: primaryContentColor,
                                ),
                                color: primaryContentColor,
                                iconSize: mediumSize,
                                padding: EdgeInsets.all(10),
                                onPressed: () {
                                  setState(() {
                                    if (isCollapsed) {
                                      _animationController.forward();
                                    } else {
                                      _animationController.reverse();
                                    }
                                    isCollapsed = !isCollapsed;
                                  });
                                }),
                          ),
                          Center(
                            child: CircleAvatar(
                              backgroundImage:
                                  _listUser[0].foto == 'assets/images/akun.jpg'
                                      ? AssetImage('assets/images/akun.jpg')
                                      : CachedNetworkImageProvider(
                                          _listUser[0].foto),
                              radius: 50,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 45),
                              child: Text(
                                _listUser[0].nama,
                                style: TextStyle(
                                  fontSize: tinySize,
                                  fontFamily: primaryFont,
                                  fontWeight: fontBold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 10, top: 10, bottom: 15, left: 10),
                              child: Text(
                                _listUser[0].whatsapp,
                                style: TextStyle(
                                  fontSize: microSize,
                                  fontFamily: primaryFont,
                                  color: primaryContentColor,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: 10, top: 10, left: 10),
                              child: Text(
                                _listUser[0].email,
                                style: TextStyle(
                                  fontSize: microSize,
                                  fontFamily: primaryFont,
                                  color: primaryContentColor,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: primaryContentColor,
                                ),
                                color: primaryContentColor,
                                iconSize: mediumSize,
                                padding: EdgeInsets.all(10),
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pushNamed(UserForm.id,
                                        arguments: _listUser[0]);
                                  });
                                }),
                          ),
                        ],
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
                                left: 10,
                                right: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.collections_bookmark,
                                          size: smallSize,
                                          color: primaryContentColor),
                                      SizedBox(
                                        width: smallSize,
                                      ),
                                      Text(
                                        'Kode Referral',
                                        style: TextStyle(
                                            color: primaryContentColor,
                                            fontSize: smallSize,
                                            fontFamily: primaryFont),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _listUser[0].id,
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                            onLongPress: () {
                              Clipboard.setData(
                                  ClipboardData(text: _listUser[0].id));
                              Fluttertoast.showToast(
                                  msg: 'Referral : ' +
                                      _listUser[0].id +
                                      ' (Copied)',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      primaryContentColor.withOpacity(0.5),
                                  textColor: secondaryContentColor,
                                  fontSize: microSize);
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.monetization_on,
                                          size: smallSize,
                                          color: primaryContentColor),
                                      SizedBox(
                                        width: smallSize,
                                      ),
                                      Text(
                                        'Rekening',
                                        style: TextStyle(
                                            color: primaryContentColor,
                                            fontSize: smallSize,
                                            fontFamily: primaryFont),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _listUser[0].rekening,
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                            onLongPress: () {
                              Clipboard.setData(
                                  ClipboardData(text: _listUser[0].rekening));
                              Fluttertoast.showToast(
                                  msg: 'Rekening : ' +
                                      _listUser[0].rekening +
                                      ' (Copied)',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      primaryContentColor.withOpacity(0.5),
                                  textColor: secondaryContentColor,
                                  fontSize: microSize);
                            },
                          ),
                          (_access == 'Produsen' || _access == 'Admin')
                              ? InkWell(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.art_track,
                                            size: smallSize,
                                            color: primaryContentColor),
                                        SizedBox(
                                          width: smallSize,
                                        ),
                                        Text(
                                          'Franchise-Ku',
                                          style: TextStyle(
                                              color: primaryContentColor,
                                              fontSize: smallSize,
                                              fontFamily: primaryFont),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    _myFranchise.length > 0
                                        ? Navigator.of(context).pushNamed(
                                            FranchiseForm.id,
                                            arguments: _myFranchise[0])
                                        : Navigator.of(context)
                                            .pushNamed(FranchiseForm.id);
                                  },
                                )
                              : SizedBox(),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
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
                                    'Kebijakan Privasi',
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
                                left: 10,
                                right: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.assignment,
                                      size: smallSize,
                                      color: primaryContentColor),
                                  SizedBox(
                                    width: smallSize,
                                  ),
                                  Text(
                                    'Syarat dan Ketentuan',
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
                                left: 10,
                                right: 10,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.info_outline,
                                          size: smallSize,
                                          color: primaryContentColor),
                                      SizedBox(
                                        width: smallSize,
                                      ),
                                      Text(
                                        'Informasi Versi',
                                        style: TextStyle(
                                            color: primaryContentColor,
                                            fontSize: smallSize,
                                            fontFamily: primaryFont),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'V-1.0.0',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: tinySize,
                                          fontFamily: primaryFont),
                                    ),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 10,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
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
                          onTap: () {
                            _showConfirmationLogout(context);
                          },
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
      left: isCollapsed ? 0 : 0.6 * MediaQuery.of(context).size.width,
      right: isCollapsed ? 0 : -0.4 * MediaQuery.of(context).size.width,
      child: ScaleTransition(
        scale: _dashboardScaleAnimation,
        child: AbsorbPointer(
          absorbing: (isCollapsed) ? false : true,
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
              /*title: Text(
                'Best Franchise',
                style: TextStyle(
                    fontFamily: secondaryFont,
                    color: primaryColor,
                    fontSize: largeSize),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                ),
              ],*/
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
              padding:
                  EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Promo',
                  style: TextStyle(
                      fontFamily: primaryFont,
                      color: primaryContentColor,
                      fontSize: smallSize,
                      fontWeight: fontBold),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    images: _listImagePromo,
                    dotSize: 3.0,
                    dotSpacing: 15.0,
                    dotColor: secondaryContentColor,
                    indicatorBgPadding: 5.0,
                    dotBgColor: transparent,
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  thickness: 0.5,
                  color: primaryLightContentColor,
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 75,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            var nominal = 0;
                            if (_listUser[0].poin >= 5000 &&
                                _listUser[0].poin < 10000) {
                              nominal = 5000;
                            } else if (_listUser[0].poin >= 10000 &&
                                _listUser[0].poin < 15000) {
                              nominal = 10000;
                            } else if (_listUser[0].poin == 15000) {
                              nominal = 15000;
                            }
                            (_listUser[0].poin >= 5000 &&
                                        _listUser[0].poin <= 10000) ||
                                    (_listUser[0].poin >= 10000 &&
                                        _listUser[0].poin <= 15000)
                                ? _showConfirmationRedeem(
                                    context,
                                    'Mau mencairkan dana poin ?',
                                    'Saya ingin mengajukan pencairan dana poin sejumlah.\n\nPoin : ' +
                                        nominal.toString())
                                : _showConfirmationPoinRedeem(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 6,
                                child: Image(
                                  height: 30,
                                  image: AssetImage('assets/images/poin.png'),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  'Poin',
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: microSize,
                                      fontFamily: primaryFont),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  _listUser[0].poin.toString(),
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: microSize,
                                      fontFamily: primaryFont),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _showConfirmationRedeem(
                                context,
                                'Mau mencairkan dana komisi ?',
                                'Saya ingin mengajukan pencairan dana komisi sejumlah.\n\nKomisi : ' +
                                    _listUser[0].komisi.toString());
                          },
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 6,
                                child: Image(
                                  height: 30,
                                  image: AssetImage('assets/images/komisi.png'),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  'Komisi',
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: microSize,
                                      fontFamily: primaryFont),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  _listUser[0].komisi.toString(),
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: microSize,
                                      fontFamily: primaryFont),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _showConfirmationRedeem(
                                context,
                                'Mau mencairkan dana royalty ?',
                                'Saya ingin mengajukan pencairan dana royalty sejumlah.\n\nRoyalty : ' +
                                    _listUser[0].royalty.toString());
                          },
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 6,
                                child: Image(
                                  height: 30,
                                  image:
                                      AssetImage('assets/images/royalty.png'),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  'Royalty',
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: microSize,
                                      fontFamily: primaryFont),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  _listUser[0].royalty.toString(),
                                  style: TextStyle(
                                      color: primaryContentColor,
                                      fontSize: microSize,
                                      fontFamily: primaryFont),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: primaryLightContentColor,
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(Office.id);
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/kantor.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Kantor',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(EmptyList.id, arguments: 'Cabang');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/cabang.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Cabang',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(FranchiseList.id,
                                  arguments: 'Antaran');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image: AssetImage('assets/images/pangan.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Pangan',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(FranchiseList.id,
                                  arguments: 'Sandang');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/sandang.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Sandang',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(FranchiseList.id,
                                  arguments: 'Papan');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image: AssetImage('assets/images/papan.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Papan',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(FranchiseList.id,
                                  arguments: 'Jajanan');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/jajanan.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Jajanan',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(FranchiseList.id,
                                  arguments: 'Oleh-Oleh');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image: AssetImage('assets/images/oleh.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Oleh-Oleh',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(FranchiseList.id,
                                  arguments: 'Antaran');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/antaran.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Antaran',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (_access == 'Admin') {
                                Navigator.of(context).pushNamed(UserList.id);
                              } else {
                                Navigator.of(context)
                                    .pushNamed(UserList.id, arguments: 'Ya');
                              }
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/leader.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    (_access == 'Admin')
                                        ? 'Pengguna'
                                        : 'Leader',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(EmptyList.id, arguments: 'Profit');
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/profit.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Profit',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(Supplier.id);
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image: AssetImage(
                                        'assets/images/supplier.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Supplier',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _showConfirmationAlert(context, msgModal);
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/modal.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Modal',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(Ask.id);
                            },
                            child: Column(
                              children: <Widget>[
                                Flexible(
                                  flex: 6,
                                  child: Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/images/tanya.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Tanya',
                                    style: TextStyle(
                                        color: primaryContentColor,
                                        fontSize: microSize,
                                        fontFamily: primaryFont),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 0.5,
                  color: primaryLightContentColor,
                ),
                SizedBox(height: 10),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Franchise',
                        style: TextStyle(
                            fontFamily: primaryFont,
                            color: primaryContentColor,
                            fontSize: smallSize,
                            fontWeight: fontBold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(FranchiseList.id);
                        },
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(
                              fontFamily: primaryFont,
                              color: secondaryColor,
                              fontSize: tinySize),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    images: _listImagePromo,
                    dotSize: 3.0,
                    dotSpacing: 15.0,
                    dotColor: secondaryContentColor,
                    indicatorBgPadding: 5.0,
                    dotBgColor: transparent,
//                  borderRadius: true,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: secondaryContentColor,
              backgroundColor: primaryColor,
              buttonBackgroundColor: secondaryContentColor,
              height: 50,
              animationDuration: Duration(milliseconds: 500),
              animationCurve: Curves.fastOutSlowIn,
              index: 2,
              items: [
                Icon(Icons.thumb_up,
                    size: mediumSize, color: primaryContentColor),
                Icon(Icons.library_books,
                    size: mediumSize, color: primaryContentColor),
                Icon(Icons.dashboard,
                    size: mediumSize, color: primaryContentColor),
                Icon(Icons.notifications_active,
                    size: mediumSize, color: primaryContentColor),
                Icon(Icons.account_circle,
                    size: mediumSize, color: primaryContentColor),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context)
                      .pushNamed(EmptyList.id, arguments: 'Rekomendasi');
                } else if (index == 1) {
                  Navigator.of(context)
                      .pushNamed(EmptyList.id, arguments: 'Feed');
                } else if (index == 3) {
                  Navigator.of(context)
                      .pushNamed(EmptyList.id, arguments: 'Notifikasi');
                } else if (index == 4) {
                  Navigator.of(context)
                      .pushNamed(UserForm.id, arguments: _listUser[0]);
                }
                debugPrint('this is index-$index');
              },
            ),
          ),
        ),
      ),
    );
  }
}
