import 'package:flutter/material.dart';
import 'package:umkamu/sidebar_menu_dashboard_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMkaMu',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SidebarMenuDashboardPage(),
    );
  }
}
