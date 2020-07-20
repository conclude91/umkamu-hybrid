import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/pages/ask.dart';
import 'package:umkamu/pages/dashboard.dart';
import 'package:umkamu/pages/empty_list.dart';
import 'package:umkamu/pages/franchise_detail.dart';
import 'package:umkamu/pages/franchise_form.dart';
import 'package:umkamu/pages/franchise_list.dart';
import 'package:umkamu/pages/login.dart';
import 'package:umkamu/pages/myhomepage.dart';
import 'package:umkamu/pages/new_franchise_form.dart';
import 'package:umkamu/pages/office.dart';
import 'package:umkamu/pages/onboarding.dart';
import 'package:umkamu/pages/register.dart';
import 'package:umkamu/pages/splashscreen.dart';
import 'package:umkamu/pages/supplier.dart';
import 'package:umkamu/pages/user_form.dart';
import 'package:umkamu/pages/user_list.dart';
import 'package:umkamu/providers/franchise_provider.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/services/firestore_service.dart';
import 'package:umkamu/utils/function.dart';
import 'package:umkamu/utils/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    setStatusBarColor(primaryColor);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => FranchiseProvider()),
        StreamProvider(create: (context) => firestoreService.getAllUser()),
        StreamProvider(create: (context) => firestoreService.getAllFranchise()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          OnBoarding.id: (context) => OnBoarding(),
          Login.id: (context) => Login(),
          Register.id: (context) => Register(),
          Dashboard.id: (context) => Dashboard(),
          UserList.id: (context) =>
              UserList(ModalRoute.of(context).settings.arguments),
          UserForm.id: (context) =>
              UserForm(ModalRoute.of(context).settings.arguments),
          FranchiseList.id: (context) =>
              FranchiseList(ModalRoute.of(context).settings.arguments),
          FranchiseForm.id: (context) =>
              FranchiseForm(ModalRoute.of(context).settings.arguments),
          FranchiseDetail.id: (context) =>
              FranchiseDetail(ModalRoute.of(context).settings.arguments),
          Ask.id: (context) => Ask(),
          Supplier.id: (context) => Supplier(),
          MyHomePage.id: (context) => MyHomePage(),
          Office.id: (context) => Office(),
          EmptyList.id: (context) =>
              EmptyList(ModalRoute.of(context).settings.arguments),
          NewFranchiseForm.id: (context) =>
              NewFranchiseForm(ModalRoute.of(context).settings.arguments),
        },
      ),
    );
  }
}
