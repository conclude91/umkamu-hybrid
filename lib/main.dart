import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/login.dart';
import 'package:umkamu/pages/myhomepage.dart';
import 'package:umkamu/pages/onboarding.dart';
import 'package:umkamu/pages/register.dart';
import 'package:umkamu/pages/splashscreen.dart';
import 'package:umkamu/pages/user_form.dart';
import 'package:umkamu/pages/user_list.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/services/firestore_service.dart';
import 'package:umkamu/utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setStatusBarColor(primaryColor);
    final firestoreService = FirestoreService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        StreamProvider(create: (context) => firestoreService.getAllUser()),
      ],
      child: MaterialApp(
        title: appName,
        initialRoute: UserList.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          OnBoarding.id: (context) => OnBoarding(),
          Login.id: (context) => Login(),
          Register.id: (context) => Register(),
          Dashboard.id: (context) => Dashboard(),
          UserList.id: (context) => UserList(),
          UserForm.id: (context) =>
              UserForm(ModalRoute.of(context).settings.arguments),
          MyHomePage.id: (context) => MyHomePage(),
        },
      ),
    );
  }
}
