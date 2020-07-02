import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/pages/user_form.dart';
import 'package:umkamu/utils/theme.dart';

class UserList extends StatefulWidget {
  static const String id = "userlist";

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  TextEditingController _filterController = new TextEditingController();
  List<User> _listUser;
  List<User> _filterListUser = [];
  double _screenWidth, _screenHeight;
  Size _size;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _filterController.dispose();
  }

  _onFilterTextChanged(String text) async {
    _filterListUser.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _listUser.forEach((user) {
      if (user.nama.toLowerCase().contains(text.toLowerCase()) ||
          user.id.toLowerCase().contains(text.toLowerCase()) ||
          user.whatsapp.toLowerCase().contains(text.toLowerCase())) {
        _filterListUser.add(user);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _listUser = Provider.of<List<User>>(context);
    _size = MediaQuery.of(context).size;
    _screenWidth = _size.width;
    _screenHeight = _size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "List User",
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: primaryContentColor),
            onPressed: () => Navigator.of(context).pushNamed(UserForm.id),
          ),
        ],
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
            width: _screenWidth,
            height: 45,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            child: TextField(
              controller: _filterController,
              onChanged: _onFilterTextChanged,
              style: TextStyle(
                fontSize: smallSize,
                color: primaryContentColor,
                fontFamily: primaryFont,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Siapa yang kamu cari ?',
                prefixIcon: Icon(Icons.location_searching,
                    size: smallSize, color: primaryContentColor),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: shadow,
            ),
          ),
          (_listUser != null)
              ? (_filterListUser.length != 0 ||
                      _filterController.text.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filterListUser.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 135,
                          child: Card(
                            elevation: 1,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  UserForm.id,
                                  arguments: _filterListUser[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      child: Image(
                                        image: CachedNetworkImageProvider(
                                            _filterListUser[index].foto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Stack(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    _filterListUser[index].nama,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: smallSize,
                                                      color:
                                                          primaryContentColor,
                                                      fontWeight: fontBold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.account_box,
                                                        color: accentColor,
                                                        size: tinySize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _filterListUser[index]
                                                            .tipe,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: tinySize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.phone,
                                                        color: secondaryColor,
                                                        size: tinySize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _filterListUser[index]
                                                            .whatsapp,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: tinySize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.email,
                                                        color: primaryColor,
                                                        size: tinySize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _filterListUser[index]
                                                            .email,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: tinySize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                _filterListUser[index].id,
                                                style: TextStyle(
                                                  fontFamily: primaryFont,
                                                  fontSize: microSize,
                                                  color: primaryContentColor,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Row(
                                                children: <Widget>[
                                                  (_filterListUser[index]
                                                              .jenis_kelamin ==
                                                          'Laki-Laki')
                                                      ? Icon(
                                                          MdiIcons.genderMale,
                                                          color: secondaryColor,
                                                          size: tinySize,
                                                        )
                                                      : Icon(
                                                          MdiIcons.genderFemale,
                                                          color: primaryColor,
                                                          size: tinySize,
                                                        ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    _filterListUser[index]
                                                        .jenis_kelamin,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: tinySize,
                                                      color:
                                                          primaryContentColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: (_filterListUser[index]
                                                          .leader ==
                                                      'Ya')
                                                  ? Icon(
                                                      MdiIcons.crownOutline,
                                                      color: gold,
                                                      size: smallSize,
                                                    )
                                                  : SizedBox(
                                                      width: 5,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listUser.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 135,
                          child: Card(
                            elevation: 1,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  UserForm.id,
                                  arguments: _listUser[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      child: Image(
                                        image: CachedNetworkImageProvider(
                                            _listUser[index].foto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Stack(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    _listUser[index].nama,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: smallSize,
                                                      color:
                                                          primaryContentColor,
                                                      fontWeight: fontBold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.account_box,
                                                        color: accentColor,
                                                        size: tinySize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _listUser[index].tipe,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: tinySize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.phone,
                                                        color: secondaryColor,
                                                        size: tinySize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _listUser[index]
                                                            .whatsapp,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: tinySize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.email,
                                                        color: primaryColor,
                                                        size: tinySize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _listUser[index].email,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: tinySize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                _listUser[index].id,
                                                style: TextStyle(
                                                  fontFamily: primaryFont,
                                                  fontSize: microSize,
                                                  color: primaryContentColor,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Row(
                                                children: <Widget>[
                                                  (_listUser[index]
                                                              .jenis_kelamin ==
                                                          'Laki-Laki')
                                                      ? Icon(
                                                          MdiIcons.genderMale,
                                                          color: secondaryColor,
                                                          size: tinySize,
                                                        )
                                                      : Icon(
                                                          MdiIcons.genderFemale,
                                                          color: primaryColor,
                                                          size: tinySize,
                                                        ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    _listUser[index]
                                                        .jenis_kelamin,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: tinySize,
                                                      color:
                                                          primaryContentColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: (_listUser[index].leader ==
                                                      'Ya')
                                                  ? Icon(
                                                      MdiIcons.crownOutline,
                                                      color: gold,
                                                      size: smallSize,
                                                    )
                                                  : SizedBox(
                                                      width: 5,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
