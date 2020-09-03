import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' show get;
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import 'package:umkamu/models/contact.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/providers/franchise_provider.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/theme.dart';

class FranchiseDetail extends StatefulWidget {
  static const String id = 'franchisedetail';
  final Franchise franchise;

  FranchiseDetail(this.franchise);

  @override
  _FranchiseDetailState createState() => _FranchiseDetailState();
}

class _FranchiseDetailState extends State<FranchiseDetail> {
  UserProvider _userProvider;
  FranchiseProvider _franchiseProvider;
  List<NetworkImage> _listImage;
  String _imageData;
  String _idUser;
  DateTime _currentTime;
  String _date;
  List<Contact> _listContact = [];
  String _noFranchise = '';

  @override
  void initState() {
    super.initState();
    _getPreferences();
    _getCurrentTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getCurrentTime() async {
    DateTime currentTime = await NTP.now();
    setState(() {
      _currentTime = currentTime;
    });
  }

  Future<String> _getFileFromURL(String url) async {
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/temp";
    var filePathAndName = documentDirectory.path + '/temp/file';
    await Directory(firstPath).create(recursive: true);
    File file = new File(filePathAndName);
    file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      _imageData = filePathAndName;
    });
    return _imageData;
  }

  _setImageList() {
    setState(() {
      _listImage = [
        NetworkImage(_franchiseProvider.foto1),
        NetworkImage(_franchiseProvider.foto2),
        NetworkImage(_franchiseProvider.foto3),
      ];
    });
  }

  _showConfirmationAlert(
      BuildContext context, String contact, String title, String msg) {
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
            title: Text("Teruskan"),
            onPressed: () {
              FlutterOpenWhatsapp.sendSingleMessage(
                  contact, msg + _getIdentityMessage());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _getIdentityMessage() {
    return '\n\nBerikut data diri saya :\n\nNama : ' +
        _userProvider.nama +
        '\nID : ' +
        _userProvider.id +
        '\nRekening : ' +
        _userProvider.rekening;
  }

  _setPreferences(String name, String date) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(name, date);
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('id') ?? '';
      _date = prefs.getString('date') ?? '';
    });
  }

  _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<Contact>>(context) != null) {
      _listContact = Provider.of<List<Contact>>(context, listen: false)
          .where((contact) => contact.id == '0')
          .toList();
    }
    if (_listContact.length == 1) {
      _noFranchise = _replaceCharAt(_listContact[0].no_franchise, 0, '+62');
    }
    _userProvider = Provider.of<UserProvider>(context);
    _franchiseProvider = Provider.of<FranchiseProvider>(context);
    var _listFranchise = Provider.of<List<Franchise>>(context)
        .where((franchise) => franchise.id == widget.franchise.id)
        .toList();
    var _listUser = Provider.of<List<User>>(context)
        .where((user) => user.id == _idUser)
        .toList();
    _userProvider.user = _listUser.length > 0 ? _listUser[0] : null;
    _franchiseProvider.franchise =
        _listFranchise.length > 0 ? _listFranchise[0] : null;
    _setImageList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          _franchiseProvider.nama,
          style: TextStyle(
            color: primaryContentColor,
            fontSize: mediumSize,
            fontFamily: primaryFont,
            fontWeight: fontBold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryContentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          child: Container(
            color: shadow,
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 50),
            children: <Widget>[
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  images: _listImage,
                  dotSize: 3.0,
                  dotSpacing: 15.0,
                  dotColor: secondaryContentColor,
                  indicatorBgPadding: 5.0,
                  dotBgColor: transparent,
//                  borderRadius: true,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      _franchiseProvider.nama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryContentColor,
                        fontSize: largeSize,
                        fontFamily: primaryFont,
                        fontWeight: fontBold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: smallSize,
                      ),
                      SizedBox(width: 5),
                      Text(
                        _franchiseProvider.kota,
                        style: TextStyle(
                          color: primaryContentColor,
                          fontSize: smallSize,
                          fontFamily: primaryFont,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 25,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/facebook.png'),
                              ),
                              onTap: () async {
                                SocialShare.shareFacebookStory(
                                    await _getFileFromURL(
                                        _franchiseProvider.foto1),
                                    primaryColorHex,
                                    primaryColorHex,
                                    'https://api.whatsapp.com/send?phone=' +
                                        _noFranchise +
                                        '&text=Hai%20Admin,%0A%0ASaya%20tertarik%20ingin%20bergabung%20dengan%20usaha%20' +
                                        Uri.encodeComponent(
                                            _franchiseProvider.nama) +
                                        '%20.%0A%0AID%20Referral%20%20%3A%20' +
                                        _userProvider.id,
                                    appId: '292360518665049');
                                var difDay;
                                if (_date != '') {
                                  difDay = _currentTime
                                      .difference(DateTime.parse(_date))
                                      .inDays;
                                } else {
                                  difDay = 0;
                                }

                                if (_userProvider.poin >= 15000) {
                                  _userProvider.poin = 0;
                                } else {
                                  if (difDay > 0) {
                                    _userProvider.poin = 0;
                                  }
                                  _userProvider.poin = _userProvider.poin + 1;
                                }
                                _setPreferences(
                                    'date',
                                    DateFormat('yyyy-MM-dd')
                                        .format(_currentTime));
                                _userProvider.save();
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/instagram.png'),
                              ),
                              onTap: () async {
                                SocialShare.shareInstagramStory(
                                        await _getFileFromURL(
                                            _franchiseProvider.foto1),
                                        primaryColorHex,
                                        primaryColorHex,
                                        'https://api.whatsapp.com/send?phone=' +
                                            _noFranchise +
                                            '&text=Hai%20Admin,%0A%0ASaya%20tertarik%20ingin%20bergabung%20dengan%20usaha%20' +
                                            Uri.encodeComponent(
                                                _franchiseProvider.nama) +
                                            '%20.%0A%0AID%20Referral%20%20%3A%20' +
                                            _userProvider.id)
                                    .then((data) {
                                  print(data);
                                });
                                var difDay;
                                if (_date != '') {
                                  difDay = _currentTime
                                      .difference(DateTime.parse(_date))
                                      .inDays;
                                } else {
                                  difDay = 0;
                                }

                                if (_userProvider.poin >= 15000) {
                                  _userProvider.poin = 0;
                                } else {
                                  if (difDay > 0) {
                                    _userProvider.poin = 0;
                                  }
                                  _userProvider.poin = _userProvider.poin + 1;
                                }
                                _setPreferences(
                                    'date',
                                    DateFormat('yyyy-MM-dd')
                                        .format(_currentTime));
                                _userProvider.save();
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/twitter.webp'),
                              ),
                              onTap: () async {
                                SocialShare.shareTwitter(
                                    'Ingin membuka usaha ini dengan mudah ? Klik link di bawah ini :',
                                    hashtags: [
                                      appName,
                                      _franchiseProvider.nama,
                                      'bisnis',
                                      'usaha'
                                    ],
                                    url: 'https://api.whatsapp.com/send?phone=' +
                                        _noFranchise +
                                        '&text=Hai%20Admin,%0A%0ASaya%20tertarik%20ingin%20bergabung%20dengan%20usaha%20' +
                                        Uri.encodeComponent(
                                            _franchiseProvider.nama) +
                                        '%20.%0A%0AID%20Referral%20%20%3A%20' +
                                        _userProvider.id);
                                var difDay;
                                if (_date != '') {
                                  difDay = _currentTime
                                      .difference(DateTime.parse(_date))
                                      .inDays;
                                } else {
                                  difDay = 0;
                                }

                                if (_userProvider.poin >= 15000) {
                                  _userProvider.poin = 0;
                                } else {
                                  if (difDay > 0) {
                                    _userProvider.poin = 0;
                                  }
                                  _userProvider.poin = _userProvider.poin + 1;
                                }
                                _setPreferences(
                                    'date',
                                    DateFormat('yyyy-MM-dd')
                                        .format(_currentTime));
                                _userProvider.save();
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/whatsapp.png'),
                              ),
                              onTap: () {
                                SocialShare.shareWhatsapp(
                                        'https://api.whatsapp.com/send?phone=' +
                                            _noFranchise +
                                            '&text=Hai%20Admin,%0A%0ASaya%20tertarik%20ingin%20bergabung%20dengan%20usaha%20' +
                                            Uri.encodeComponent(
                                                _franchiseProvider.nama) +
                                            '%20.%0A%0AID%20Referral%20%20%3A%20' +
                                            _userProvider.id)
                                    .then((data) {
                                  print(data);
                                });
                                var difDay;
                                if (_date != '') {
                                  difDay = _currentTime
                                      .difference(DateTime.parse(_date))
                                      .inDays;
                                } else {
                                  difDay = 0;
                                }

                                if (_userProvider.poin >= 15000) {
                                  _userProvider.poin = 0;
                                } else {
                                  if (difDay > 0) {
                                    _userProvider.poin = 0;
                                  }
                                  _userProvider.poin = _userProvider.poin + 1;
                                }
                                _setPreferences(
                                    'date',
                                    DateFormat('yyyy-MM-dd')
                                        .format(_currentTime));
                                _userProvider.save();
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              child: Image(
                                image:
                                    ExactAssetImage('assets/images/copy.png'),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: 'https://api.whatsapp.com/send?phone=' +
                                        _noFranchise +
                                        '&text=Hai%20Admin,%0A%0ASaya%20tertarik%20ingin%20bergabung%20dengan%20usaha%20' +
                                        Uri.encodeComponent(
                                            _franchiseProvider.nama) +
                                        '%20.%0A%0AID%20Referral%20%20%3A%20' +
                                        _userProvider.id));
                                Fluttertoast.showToast(
                                    msg: 'Share Link : (Copied)',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        primaryContentColor.withOpacity(0.5),
                                    textColor: secondaryContentColor,
                                    fontSize: microSize);
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/message.png'),
                              ),
                              onTap: () {
                                SocialShare.shareSms(
                                        "Tertarik dengan usaha seperti ini ? Jika tertarik klik tautan di bawah ini untuk informasi lebih lanjut :\n\n",
                                        url: 'https://api.whatsapp.com/send?phone=' +
                                            _noFranchise +
                                            '&text=Hai%20Admin,%0A%0ASaya%20tertarik%20ingin%20bergabung%20dengan%20usaha%20' +
                                            Uri.encodeComponent(
                                                _franchiseProvider.nama) +
                                            '%20.%0A%0AID%20Referral%20%20%3A%20' +
                                            _userProvider.id,
                                        trailingText:
                                            '\n\n* Pesan ini di dukung oleh ' +
                                                appName +
                                                '.')
                                    .then((data) {
                                  print(data);
                                });
                                var difDay;
                                if (_date != '') {
                                  difDay = _currentTime
                                      .difference(DateTime.parse(_date))
                                      .inDays;
                                } else {
                                  difDay = 0;
                                }

                                if (_userProvider.poin >= 15000) {
                                  _userProvider.poin = 0;
                                } else {
                                  if (difDay > 0) {
                                    _userProvider.poin = 0;
                                  }
                                  _userProvider.poin = _userProvider.poin + 1;
                                }
                                _setPreferences(
                                    'date',
                                    DateFormat('yyyy-MM-dd')
                                        .format(_currentTime));
                                _userProvider.save();
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(
                color: primaryLightContentColor,
                thickness: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: _franchiseProvider.deskripsi,
                    style: TextStyle(
                      color: primaryContentColor,
                      fontSize: microSize,
                      fontFamily: primaryFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              color: transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 5,
                    child: Material(
                      color: primaryColor,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            'Berminat',
                            style: TextStyle(
                                fontSize: tinySize,
                                fontFamily: primaryFont,
                                color: secondaryContentColor,
                                fontWeight: fontBold),
                          ),
                        ),
                        onTap: () {
                          _showConfirmationAlert(
                              context,
                              _noFranchise,
                              'Berminat bergabung dengan usaha ini ?',
                              'Hai Admin\n\nSaya berminat bergabung dengan bisnis Franchise : ' +
                                  _franchiseProvider.nama +
                                  '.');
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.5,
                    child: Container(
                      color: secondaryContentColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 5,
                    child: Material(
                      color: primaryColor,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            'Konsultasi',
                            style: TextStyle(
                                color: secondaryContentColor,
                                fontSize: tinySize,
                                fontFamily: primaryFont,
                                fontWeight: fontBold),
                          ),
                        ),
                        onTap: () {
                          _showConfirmationAlert(
                              context,
                              _replaceCharAt(
                                  _franchiseProvider.whatsapp, 0, '+62'),
                              'Ingin tahu lebih lanjut mengenai usaha ini ?',
                              'Hai Owner\n\nSaya tertarik ingin tau lebih lanjut mengenai Franchise : ' +
                                  _franchiseProvider.nama +
                                  '. Bolehkan saya berkonsultasi ? Ada beberapa hal yang ingin saya tanyakan.');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
