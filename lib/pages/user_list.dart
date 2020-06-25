import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  @override
  Widget build(BuildContext context) {
    final listUser = Provider.of<List<User>>(context);
    Size size = MediaQuery.of(context).size;
    double screenWidth, screenHeight;
    screenWidth = size.width;
    screenHeight = size.height;

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
            width: screenWidth,
            height: 45,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_searching,
                      size: mediumSize, color: primaryContentColor),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Apa yang kamu cari?',
                    style: TextStyle(
                        color: primaryContentColor,
                        fontSize: tinySize,
                        fontFamily: primaryFont),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: shadow,
            ),
          ),
          (listUser != null)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: listUser.length,
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
                              arguments: listUser[index]),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(3),
                                    bottomLeft: Radius.circular(3),
                                  ),
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        listUser[index].foto),
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
                                                listUser[index].nama,
                                                style: TextStyle(
                                                  fontFamily: primaryFont,
                                                  fontSize: smallSize,
                                                  color: primaryContentColor,
                                                  fontWeight: fontBold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.account_box,
                                                    color: accentColor,
                                                    size: smallSize,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    listUser[index].tipe,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: tinySize,
                                                      color:
                                                          primaryContentColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.phone,
                                                    color: secondaryColor,
                                                    size: smallSize,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    listUser[index].whatsapp,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
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
                                                    size: smallSize,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    listUser[index].email,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
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
