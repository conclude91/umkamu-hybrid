import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/utils/function.dart';
import 'package:umkamu/utils/theme.dart';

import 'login.dart';

class Register extends StatefulWidget {
  static const String id = "register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  UserProvider _userProvider;
  List<User> _listUser;
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _whatsappController = TextEditingController();
  bool _namaError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _whatsappError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _userProvider.id = DateTime.now().millisecondsSinceEpoch.toString();
      _userProvider.foto = 'assets/images/akun.jpg';
      _userProvider.jenis_kelamin = 'Laki-Laki';
      _userProvider.rekening = '0';
      _userProvider.poin = 0;
      _userProvider.komisi = 0;
      _userProvider.royalty = 0;
      _userProvider.tipe = 'Konsumen';
      _userProvider.leader = 'Tidak';
      _namaController.text = '';
      _emailController.text = '';
      _passwordController.text = '';
      _whatsappController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappController.dispose();
  }

  _showConfirmationAlert(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          "Konfirmasi",
          style: TextStyle(
              fontFamily: primaryFont,
              fontSize: mediumSize,
              color: primaryContentColor),
        ),
        content: Text(
          "Pastikan kamu sudah mengisi data dengan benar.\n"
                  "Dengan menekan tombol ini kamu telah menyetujui syarat dan ketentuan yang berlaku di " +
              appName +
              ".",
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
            title: Text("Setuju"),
            onPressed: () {
              _userProvider.save();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<User>>(context) != null) {
      _listUser = Provider.of<List<User>>(context)
          .where((user) => user.email == _emailController.text)
          .toList();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/doodle-potrait.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: Image(
                        color: primaryColor,
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: primaryContentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.account_circle,
                      color: primaryContentColor,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: _namaController,
                      textAlign: TextAlign.center,
                      maxLength: 50,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'Nama Lengkap',
                        hintStyle: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: tinySize,
                        ),
                        errorText: _namaError ? 'Field ini harus diisi' : null,
                      ),
                      onChanged: (value) => _userProvider.nama = value,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: primaryContentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.alternate_email,
                      color: primaryContentColor,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'email@mu.com',
                        hintStyle: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: tinySize,
                        ),
                        errorText: _emailError ? 'Field ini harus diisi' : null,
                      ),
                      onChanged: (value) => _userProvider.email = value,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: primaryContentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.lock_open,
                      color: primaryContentColor,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: _passwordController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: tinySize,
                        ),
                        errorText:
                            _passwordError ? 'Field ini harus diisi' : null,
                      ),
                      onChanged: (value) => _userProvider.password = value,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: primaryContentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.phone_android,
                      color: primaryContentColor,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: TextField(
                      controller: _whatsappController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'No WhatsApp',
                        hintStyle: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: tinySize,
                        ),
                        errorText:
                            _whatsappError ? 'Field ini harus diisi' : null,
                      ),
                      onChanged: (value) => _userProvider.whatsapp = value,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: primaryColor,
                      onPressed: () {
                        setState(() {
                          _namaController.text.isEmpty
                              ? _namaError = true
                              : _namaError = false;
                          _emailController.text.isEmpty
                              ? _emailError = true
                              : _emailError = false;
                          _passwordController.text.isEmpty
                              ? _passwordError = true
                              : _passwordError = false;
                          _whatsappController.text.isEmpty
                              ? _whatsappError = true
                              : _whatsappError = false;
                        });

                        if (checkEmailFormat(_emailController.text) == false) {
                          Fluttertoast.showToast(
                              msg: 'Inputan email tidak valid',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor:
                                  primaryContentColor.withOpacity(0.5),
                              textColor: secondaryContentColor,
                              fontSize: microSize);
                        }

                        if (_namaError == false &&
                            _emailError == false &&
                            checkEmailFormat(_emailController.text) &&
                            _passwordError == false &&
                            _whatsappError == false) {
                          if (_listUser.length > 0) {
                            Fluttertoast.showToast(
                                msg: 'Pendaftaran gagal.\nEmail : ' +
                                    _listUser[0].email +
                                    ' telah terdaftar sebelumya.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    primaryContentColor.withOpacity(0.5),
                                textColor: secondaryContentColor,
                                fontSize: microSize);
                          } else {
                            _showConfirmationAlert(context);
                          }
                        }
                      },
                      child: Text(
                        "Daftar",
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
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: Colors.transparent,
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? Silahkan masuk",
                            style: TextStyle(
                              color: primaryContentColor,
                              fontFamily: primaryFont,
                              fontSize: microSize,
                            ),
                          ),
                          Text(
                            "disini.",
                            style: TextStyle(
                              color: primaryContentColor,
                              fontFamily: primaryFont,
                              fontSize: microSize,
                              fontWeight: fontBold,
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
      ),
    );
  }
}
