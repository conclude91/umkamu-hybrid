import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/forgot_password.dart';
import 'package:umkamu/pages/register.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/utils/function.dart';
import 'package:umkamu/utils/theme.dart';

class Login extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserProvider _userProvider;
  List<User> _listUser = [];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _setPreferences(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('id', user.id);
    sharedPreferences.setString('access', user.tipe);
    sharedPreferences.setBool('isLogin', true);
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<User>>(context) != null) {
      _listUser = Provider.of<List<User>>(context)
          .where((user) => user.email == _emailController.text)
          .where((user) => user.password == _passwordController.text)
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
                child: new Column(
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
                      onChanged: (value) => _userProvider.email = value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'email@mu.com',
                        hintStyle: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: tinySize,
                        ),
                        errorText:
                            _emailError ? 'Field ini harus diisi' : null,
                      ),
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
                      onChanged: (value) => _userProvider.password = value,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: tinySize,
                        ),
                        errorText: _passwordError
                            ? 'Field ini harus diisi'
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
                          _emailController.text.isEmpty
                              ? _emailError = true
                              : _emailError = false;
                          _passwordController.text.isEmpty
                              ? _passwordError = true
                              : _passwordError = false;
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

                        if (_emailError == false &&
                            checkEmailFormat(_emailController.text) &&
                            _passwordError == false) {
                          if (_listUser.length > 0) {
                            _setPreferences(_listUser[0]);
                            Navigator.of(context)
                                .pushReplacementNamed(Dashboard.id);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'Login gagal.\nCek kembali inputan email dan password.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    primaryContentColor.withOpacity(0.5),
                                textColor: secondaryContentColor,
                                fontSize: microSize);
                          }
                        }
                      },
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: secondaryContentColor,
                          fontSize: tinySize,
                          fontFamily: primaryFont,
                          fontWeight: fontBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    color: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ForgotPassword.id);
                    },
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(
                        color: primaryContentColor,
                        fontFamily: primaryFont,
                        fontSize: microSize,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: Colors.transparent,
                      onPressed: () => {
                        Navigator.of(context).pushNamed(Register.id),
                      },
                      child: Text(
                        "Belum punya akun? Daftar dulu disini.",
                        style: TextStyle(
                          color: primaryContentColor,
                          fontFamily: primaryFont,
                          fontSize: microSize,
                        ),
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
