import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/function.dart';
import 'package:umkamu/utils/theme.dart';

class Office extends StatefulWidget {
  static const String id = 'office';

  @override
  _OfficeState createState() => _OfficeState();
}

class _OfficeState extends State<Office> {
  List<NetworkImage> _listImage;
  String _idUser;

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setImageList() {
    setState(() {
      _listImage = [
        NetworkImage(
            'https://www.franchiseglobal.com/images/posts/2017/11/27/RFC.JPG'),
        NetworkImage(
            'https://cdn.infobrand.id/images/img/posts/2019/03/01/targetkan-400-gerai-di-2019-rfc-siap-go-internasional.jpg'),
        NetworkImage(
            'https://www.franchiseglobal.com/images/posts/2017/12/21/best-franchisee.JPG'),
      ];
    });
  }

  /*_getIdentityMessage() {
    return '\n\nBerikut data diri saya :\n\nNama : ' +
        _userProvider.nama +
        '\nID : ' +
        _userProvider.id +
        '\nRekening : ' +
        _userProvider.rekening;
  }*/

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getString('id') ?? '';
    });
  }

  _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    _setImageList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Kantor',
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
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                      appName,
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
                  InkWell(
                    onTap: () {
                      openMap(-6.9070458, 107.6427886);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: primaryColor,
                          size: smallSize,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Bandung',
                          style: TextStyle(
                            color: primaryContentColor,
                            fontSize: smallSize,
                            fontFamily: primaryFont,
                          ),
                        ),
                      ],
                    ),
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
                              onTap: () async {},
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/instagram.png'),
                              ),
                              onTap: () async {},
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/twitter.webp'),
                              ),
                              onTap: () async {},
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              child: Image(
                                image: ExactAssetImage(
                                    'assets/images/whatsapp.png'),
                              ),
                              onTap: () {},
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
                    text: contentOffice,
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
        ],
      ),
    );
  }
}
