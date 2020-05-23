import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
      ),
    );

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UMkaMu'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Center(
        child: Image.asset('assets/background-doodle.png'),
//        child: Text(
//          'Home',
//          style: TextStyle(
//            fontSize: 20,
//            letterSpacing: 2,
//            color: Colors.blueGrey[600],
//            fontFamily: 'Roboto',
//          ),
//        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Click'),
        backgroundColor: Colors.red[600],
      ),
    );
  }
}

