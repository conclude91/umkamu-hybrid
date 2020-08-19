import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/contact.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/theme.dart';

import 'franchise_detail.dart';

class Ask extends StatefulWidget {
  static const String id = "ask";

  @override
  _AskState createState() => _AskState();
}

class _AskState extends State<Ask> {
  List<Franchise> _listFranchise = [];
  List<Contact> _listContact = [];
  String _noTanya = '';
  String _noTeknis = '';
  List<InkWell> _listImagePromo = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  _showConfirmationAskAlert(BuildContext context, String msg) {
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
              FlutterOpenWhatsapp.sendSingleMessage(_noTanya, msg);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _showConfirmationTechAlert(BuildContext context, String msg) {
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
              FlutterOpenWhatsapp.sendSingleMessage(_noTeknis, msg);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<Contact>>(context) != null) {
      _listContact = Provider.of<List<Contact>>(context, listen: false)
          .where((contact) => contact.id == '0')
          .toList();
    }
    if (_listContact.length == 1) {
      _noTanya = _replaceCharAt(_listContact[0].no_tanya, 0, '+62');
      _noTeknis = _replaceCharAt(_listContact[0].no_teknis, 0, '+62');
    }
    _listFranchise = Provider.of<List<Franchise>>(context)
        .where((franchise) => franchise.promo.toString() == 'Ya')
        .where((franchise) => franchise.disetujui == 'Ya')
        .toList();
    if (_listImagePromo.length == 0) {
      _listImagePromo.clear();
      for (int i = 0; i < _listFranchise.length; i++) {
        _listImagePromo.add(
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(FranchiseDetail.id,
                arguments: _listFranchise[i]),
            child: CachedNetworkImage(
              imageUrl: _listFranchise[i].foto1,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Tanya",
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
            width: MediaQuery.of(context).size.width,
            child: Carousel(
              images: (_listImagePromo.length > 0)
                  ? _listImagePromo
                  : [ExactAssetImage('assets/images/no-result-found.png')],
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
                          _showConfirmationAskAlert(context, msgAdmin);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image: AssetImage('assets/images/admin.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Admin',
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
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          _showConfirmationAskAlert(context, msgKonsultasi);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image: AssetImage('assets/images/consult.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Konsultasi',
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
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _showConfirmationAskAlert(context, msgCaraGabung);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image:
                                    AssetImage('assets/images/cara_gabung.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Cara Gabung',
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
                          _showConfirmationAskAlert(context, msgCaraJual);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image: AssetImage(
                                  'assets/images/cara_jual.png',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Cara Jual',
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
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          _showConfirmationAskAlert(context, msgCaraBeli);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image:
                                    AssetImage('assets/images/cara_beli.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Cara Beli',
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
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _showConfirmationTechAlert(context, msgPasangIklan);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image: AssetImage(
                                    'assets/images/pasang_iklan.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Pasang Iklan',
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
                          _showConfirmationTechAlert(context, msgKirimBerita);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image: AssetImage(
                                    'assets/images/kirim_berita.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Kirim Berita',
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
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          _showConfirmationTechAlert(context, msgKirimFoto);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image:
                                    AssetImage('assets/images/kirim_foto.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Kirim Foto',
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
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _showConfirmationTechAlert(context, msgKirimProfil);
                        },
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 6,
                              child: Image(
                                height: 50,
                                image: AssetImage(
                                    'assets/images/kirim_profil.png'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                'Kirim Profil',
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
            ],
          ),
        ],
      ),
    );
  }
}
