import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/models/contact.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/pages/ask.dart';
import 'package:umkamu/pages/empty_list.dart';
import 'package:umkamu/pages/franchise_approved_list.dart';
import 'package:umkamu/pages/franchise_detail.dart';
import 'package:umkamu/pages/franchise_list.dart';
import 'package:umkamu/pages/leader_list.dart';
import 'package:umkamu/pages/office.dart';
import 'package:umkamu/pages/splashscreen.dart';
import 'package:umkamu/pages/supplier.dart';
import 'package:umkamu/pages/underconstruction.dart';
import 'package:umkamu/pages/user_form.dart';
import 'package:umkamu/pages/user_list.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/theme.dart';

class Dashboard extends StatefulWidget {
  static const String id = "dashboard";

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  UserProvider _userProvider;
  List<User> _listUser = [];
  List<Franchise> _listFranchisePromo = [];
  List<InkWell> _listImagePromo = [];
  bool isCollapsed = true;
  Duration duration = const Duration(milliseconds: 250);
  AnimationController _animationController;
  Animation<double> _dashboardScaleAnimation;
  Animation<double> _sidebarMenuScaleAnimation;
  Animation<Offset> _slideAnimation;
  bool _isLogin;
  String _id;
  String _access;
  DateTime _currentTime;
  String _date;
  int _bottomSelectedIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  List<Contact> _listContact = [];
  String _noModal = '';

  @override
  void initState() {
    super.initState();
    _getPreferences();
    _getCurrentTime();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
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
              FlutterOpenWhatsapp.sendSingleMessage(_noModal, msg);
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
      print(key);
      if (key != 'date') {
        prefs.remove(key);
      }
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
                  _noModal, 'Hai Admin,\n\n' + msg + _getIdentityMessage());
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
          "Mau mencairkan dana poin ?",
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

  _showConfirmationKomisiRedeem(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Mau mencairkan dana komisi ?",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          "Pencairan dana komisi tidak bisa dilakukan, nominal komisi kamu masih 0.\n",
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

  _showConfirmationRoyaltyRedeem(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Mau mencairkan dana royalty ?",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          "Pencairan dana royalty tidak bisa dilakukan, nominal royalty kamu masih 0.\n",
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

  _setPreferences(String name, String data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(name, data);
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogin = prefs.getBool('isLogin') ?? false;
      _id = prefs.getString('id') ?? '';
      _access = prefs.getString('access') ?? '';
      _date = prefs.getString('date') ?? '';
    });
  }

  _getCurrentTime() async {
    DateTime currentTime = await NTP.now();
    setState(() {
      _currentTime = currentTime;
    });
  }

  _pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  _bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  _onBackpressed(int index) {
    _bottomTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<Contact>>(context) != null) {
      _listContact = Provider.of<List<Contact>>(context, listen: false)
          .where((contact) => contact.id == '0')
          .toList();
    }
    if (_listContact.length == 1) {
      _noModal = _replaceCharAt(_listContact[0].no_modal, 0, '+62');
    }
    if (Provider.of<List<User>>(context) != null) {
      _listUser = Provider.of<List<User>>(context)
          .where((user) => user.id == _id)
          .toList();
    }
    if (Provider.of<List<Franchise>>(context) != null) {
      _listFranchisePromo = Provider.of<List<Franchise>>(context)
          .where((franchise) => franchise.promo == 'Ya')
          .where((franchise) => franchise.disetujui == 'Ya')
          .toList();
    }
    if (_listFranchisePromo != null && _listFranchisePromo.length > 0) {
      if (_listImagePromo.length != _listFranchisePromo.length) {
        _listImagePromo.clear();
        for (int i = 0; i < _listFranchisePromo.length; i++) {
          _listImagePromo.add(
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(FranchiseDetail.id,
                  arguments: _listFranchisePromo[i]),
              child: CachedNetworkImage(
                imageUrl: _listFranchisePromo[i].foto1,
              ),
            ),
          );
        }
      }
    }
    if (_listUser != null && _listUser.length > 0) {
      if (_currentTime != null) {
        var difDay;
        if (_date != '') {
          difDay = _currentTime.difference(DateTime.parse(_date)).inDays;
          if (difDay > 0) {
            _userProvider.user = _listUser[0];
            _userProvider.poin = 0;
            _userProvider.save();
          }
        }
        _setPreferences('date', DateFormat('yyyy-MM-dd').format(_currentTime));
      }
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          (isCollapsed == false)
              ? WillPopScope(
                  onWillPop: () {
                    setState(() {
                      if (isCollapsed) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                      isCollapsed = !isCollapsed;
                    });
                  },
                  child: navDrawer(context),
                )
              : navDrawer(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget mainMenu() {
    return Scaffold(
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
        padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        shrinkWrap: true,
        children: [
          Text(
            'Promo',
            style: TextStyle(
                fontFamily: primaryFont,
                color: primaryContentColor,
                fontSize: smallSize,
                fontWeight: fontBold),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Carousel(
              images: (_listImagePromo.length > 0)
                  ? _listImagePromo
                  : [ExactAssetImage('assets/images/no-result-found.png')],
              dotSize: 2.0,
              dotSpacing: 15.0,
              dotColor: secondaryContentColor,
              indicatorBgPadding: 5.0,
              dotBgColor: transparent,
            ),
          ),
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
                            (_listUser.length > 0)
                                ? _listUser[0].poin.toString()
                                : '0',
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
                      (_listUser[0].komisi > 0)
                          ? _showConfirmationRedeem(
                              context,
                              'Mau mencairkan dana komisi ?',
                              'Saya ingin mengajukan pencairan dana komisi sejumlah.\n\nKomisi : ' +
                                  _listUser[0].komisi.toString())
                          : _showConfirmationKomisiRedeem(context);
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
                            (_listUser.length > 0)
                                ? NumberFormat.simpleCurrency(name: 'IDR')
                                    .format(_listUser[0].komisi)
                                : NumberFormat.simpleCurrency(name: 'IDR')
                                    .format(0),
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
                      (_listUser[0].royalty > 0)
                          ? _showConfirmationRedeem(
                              context,
                              'Mau mencairkan dana royalty ?',
                              'Saya ingin mengajukan pencairan dana royalty sejumlah.\n\nRoyalty : ' +
                                  _listUser[0].royalty.toString())
                          : _showConfirmationRoyaltyRedeem(context);
                    },
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 6,
                          child: Image(
                            height: 30,
                            image: AssetImage('assets/images/royalty.png'),
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
                            (_listUser.length > 0)
                                ? NumberFormat.simpleCurrency(name: 'IDR')
                                    .format(_listUser[0].royalty)
                                : NumberFormat.simpleCurrency(name: 'IDR')
                                    .format(0),
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
                              image: AssetImage('assets/images/kantor.png'),
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
                    /*InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(UnderConstruction.id,
                            arguments: 'Cabang');
                      },
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                            child: Image(
                              height: 45,
                              image: AssetImage('assets/images/cabang.png'),
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
                    ),*/
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
                        Navigator.of(context)
                            .pushNamed(FranchiseList.id, arguments: 'Jajanan');
                      },
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                            child: Image(
                              height: 45,
                              image: AssetImage('assets/images/jajanan.png'),
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
                        Navigator.of(context)
                            .pushNamed(FranchiseList.id, arguments: 'Antaran');
                      },
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                            child: Image(
                              height: 45,
                              image: AssetImage('assets/images/antaran.png'),
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
                        Navigator.of(context).pushNamed(LeaderList.id);
                      },
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                            child: Image(
                              height: 45,
                              image: AssetImage('assets/images/leader.png'),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              'Leader',
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
                        Navigator.of(context).pushNamed(UnderConstruction.id,
                            arguments: 'Profit');
                      },
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                            child: Image(
                              height: 45,
                              image: AssetImage('assets/images/profit.png'),
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
                    ),*/
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
                              image: AssetImage('assets/images/supplier.png'),
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
                              image: AssetImage('assets/images/modal.png'),
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
                              image: AssetImage('assets/images/tanya.png'),
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
          SizedBox(height: 5),
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
          SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Carousel(
              images: (_listImagePromo.length > 0)
                  ? _listImagePromo
                  : [ExactAssetImage('assets/images/no-result-found.png')],
              dotSize: 2.0,
              dotSpacing: 15.0,
              dotColor: secondaryContentColor,
              indicatorBgPadding: 5.0,
              dotBgColor: transparent,
//                  borderRadius: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageView() {
    return PageView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) {
        _pageChanged(index);
      },
      children: <Widget>[
        /* WillPopScope(
          onWillPop: () {
            _onBackpressed(0);
          },
          child: UnderConstruction('Rekomendasi'),
        ),
        WillPopScope(
          onWillPop: () {
            _onBackpressed(0);
          },
          child: UnderConstruction('Feed'),
        ),*/
        (isCollapsed == true)
            ? DoubleBackToCloseApp(
                snackBar: const SnackBar(
                  content: Text('Tekan sekali lagi untuk menutup aplikasi'),
                ),
                child: mainMenu(),
              )
            : mainMenu(),
        /*WillPopScope(
          onWillPop: () {
            _onBackpressed(0);
          },
          child: UnderConstruction('Notifikasi'),
        ),*/
        WillPopScope(
          onWillPop: () {
            _onBackpressed(0);
          },
          child: UserList(),
        ),
      ],
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
                              backgroundImage: (_listUser.length > 0)
                                  ? (_listUser[0].foto ==
                                          'assets/images/akun.jpg')
                                      ? AssetImage('assets/images/akun.jpg')
                                      : CachedNetworkImageProvider(
                                          _listUser[0].foto)
                                  : AssetImage('assets/images/akun.jpg'),
                              radius: 50,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 45),
                              child: Text(
                                (_listUser.length > 0) ? _listUser[0].nama : '',
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
                                (_listUser.length > 0)
                                    ? _listUser[0].whatsapp
                                    : '',
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
                                (_listUser.length > 0)
                                    ? _listUser[0].email
                                    : '',
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
                                      (_listUser.length > 0)
                                          ? _listUser[0].id
                                          : '',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: microSize,
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
                                      (_listUser.length > 0)
                                          ? _listUser[0].rekening
                                          : '',
                                      style: TextStyle(
                                          color: primaryContentColor,
                                          fontSize: microSize,
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
                                          'List Pengajuan Franchise',
                                          style: TextStyle(
                                              color: primaryContentColor,
                                              fontSize: smallSize,
                                              fontFamily: primaryFont),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(FranchiseApprovedList.id);
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
                                          fontSize: microSize,
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
            body: pageView(),
            bottomNavigationBar: CurvedNavigationBar(
              color: secondaryContentColor,
              backgroundColor: primaryColor,
              buttonBackgroundColor: secondaryContentColor,
              height: 50,
              animationDuration: Duration(milliseconds: 500),
              animationCurve: Curves.fastOutSlowIn,
              index: _bottomSelectedIndex,
              items: [
                /*Icon(Icons.thumb_up,
                    size: mediumSize, color: primaryContentColor),
                Icon(Icons.library_books,
                    size: mediumSize, color: primaryContentColor),*/
                Image(
                  image: ExactAssetImage('assets/images/logo.png'),
                  width: tinySize,
                  color: primaryContentColor,
                ),
                /*Icon(Icons.dashboard,
                    size: mediumSize, color: primaryContentColor),*/
                /*Icon(Icons.notifications_active,
                    size: mediumSize, color: primaryContentColor),*/
                Icon(Icons.account_circle,
                    size: mediumSize, color: primaryContentColor),
              ],
              onTap: (index) {
                _bottomTapped(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
