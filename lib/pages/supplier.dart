import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Supplier extends StatefulWidget {
  static const String id = "supplier";

  @override
  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  List<Franchise> _listFranchise;
  final List<NetworkImage> _listImagePromo = List<NetworkImage>();
  double _screenWidth, _screenHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: 'URL tidak bisa dijalankan.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryContentColor.withOpacity(0.5),
          textColor: secondaryContentColor,
          fontSize: tinySize);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _listFranchise = Provider.of<List<Franchise>>(context)
        .where((franchise) => franchise.promo.toString() == 'Ya')
        .where((franchise) => franchise.disetujui == 'Ya')
        .toList();
    if (_listImagePromo.length == 0) {
      for (int i = 0; i < _listFranchise.length; i++) {
        _listImagePromo.add(NetworkImage(_listFranchise[i].foto1));
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Supplier",
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
      body: ListView(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 200,
            width: _screenWidth,
            child: Carousel(
              images: _listImagePromo,
              dotSize: 3.0,
              dotSpacing: 15.0,
              dotColor: secondaryContentColor,
              indicatorBgPadding: 5.0,
              dotBgColor: transparent,
//              borderRadius: true,
            ),
          ),
          SizedBox(height: 10),
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
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _launchURL('https://tanihub.com');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 10,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: shadow,
                                      width: 1,
                                    )),
                                child: Image(
                                  image: AssetImage('assets/images/tanihub.png'),
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          _launchURL('http://suburmart.com/');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/suburmart.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _launchURL('https://acehardware.co.id/');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/ace.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _launchURL('https://informa.co.id/');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/informa.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          _launchURL('http://kioslistrik.com');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/kiosklistrik.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _launchURL('http://www.maxindojaya.com/');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/maxindo.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _launchURL('https://gopack.id/');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/gopack.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          _launchURL('https://twitter.com/mutiarasuperk');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                                flex: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: shadow,
                                        width: 1,
                                      )),
                                  child: Image(
                                    image: AssetImage('assets/images/mutiara.png'),
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    /*Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _launchURL('https://mcdonalds.co.id/');
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 10,
                              child: Image(
                                image: AssetImage('assets/mcd.png'),
                                height: 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
