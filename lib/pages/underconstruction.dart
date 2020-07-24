import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:umkamu/utils/theme.dart';

class UnderConstruction extends StatefulWidget {
  static const String id = "underconstruction";

  final String data;

  UnderConstruction(this.data);

  @override
  _UnderConstructionState createState() => _UnderConstructionState();
}

class _UnderConstructionState extends State<UnderConstruction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.data + ' Dalam Pengerjaan',
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
      body: Stack(
        children: <Widget>[
          Container(
            child: Center(
              child: Image(
                width: 300,
                image: AssetImage(
                  "assets/images/underconstruction.png",
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/doodle-potrait.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
