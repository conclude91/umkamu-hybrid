import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer2/mailer.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/utils/constanta.dart';
import 'package:umkamu/utils/theme.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = "forgotpassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  List<User> _listUser = [];

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  _sendEmail(String recipient, String password) {
    var options = new GmailSmtpOptions()
      ..username = adminEmail
      ..password =
          adminPassEmail; // Note: if you have Google's "app specific passwords" enabled,
    // Create our email transport.
    var emailTransport = new SmtpTransport(options);

    // Create our mail/envelope.
    var envelope = new Envelope()
      ..from = 'admin@umkamu.com'
      ..recipients.add(recipient)
      ..subject = 'Pemulihan Password ' + appName
      ..text = 'Berikut password anda : ' + password;

    // Email it.
    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<User>>(context) != null) {
      _listUser = Provider.of<List<User>>(context)
          .where((user) => user.email == _emailController.text)
          .toList();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Lupa Password',
          style: TextStyle(
            color: primaryContentColor,
            fontSize: mediumSize,
            fontFamily: primaryFont,
            fontWeight: fontBold,
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: shadow,
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            child: TextField(
              controller: _emailController,
              style: TextStyle(
                fontSize: tinySize,
                color: primaryContentColor,
                fontFamily: primaryFont,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Masukan email kamu disini',
                prefixIcon: Icon(Icons.email,
                    size: tinySize, color: primaryContentColor),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: shadow,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    color: primaryColor,
                    onPressed: () {
                      if (_listUser.length == 1) {
                        _sendEmail(
                            _emailController.text, _listUser[0].password);
                        /*Fluttertoast.showToast(
                            msg: 'Password berhasil dikirim ke email.',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                            primaryContentColor.withOpacity(0.5),
                            textColor: secondaryContentColor,
                            fontSize: microSize);*/
                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Email tidak ditemukan',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                primaryContentColor.withOpacity(0.5),
                            textColor: secondaryContentColor,
                            fontSize: microSize);
                      }
                    },
                    child: Text(
                      "Kirim Email",
                      style: TextStyle(
                        color: secondaryContentColor,
                        fontFamily: primaryFont,
                        fontSize: tinySize,
                        fontWeight: fontBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
