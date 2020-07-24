import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:umkamu/utils/theme.dart';

class EmptyList extends StatefulWidget {
  static const String id = "emptylist";

  final String data;

  EmptyList(this.data);

  @override
  _EmptyListState createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> {
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
          widget.data ?? 'List Data',
          style: TextStyle(
            color: primaryContentColor,
            fontSize: mediumSize,
            fontFamily: primaryFont,
            fontWeight: fontBold,
          ),
        ),
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryContentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),*/
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: primaryContentColor),
            onPressed: () => Navigator.of(context).pushNamed(FranchiseForm.id),
          ),
        ],*/
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
              style: TextStyle(
                fontSize: tinySize,
                color: primaryContentColor,
                fontFamily: primaryFont,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.data + ' apa yang kamu cari ?',
                prefixIcon: Icon(Icons.location_searching,
                    size: tinySize, color: primaryContentColor),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: shadow,
            ),
          ),
          Flexible(
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  'Data ' + widget.data.toLowerCase() + ' belum tersedia.',
                  style: TextStyle(
                    fontSize: tinySize,
                    fontFamily: primaryFont,
                    color: primaryContentColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
