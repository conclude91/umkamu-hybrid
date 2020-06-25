import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/pages/franchise_form.dart';
import 'package:umkamu/pages/user_form.dart';
import 'package:umkamu/utils/theme.dart';

class FranchiseList extends StatefulWidget {
  static const String id = "franchiselist";

  @override
  _FranchiseListState createState() => _FranchiseListState();
}

class _FranchiseListState extends State<FranchiseList> {
  @override
  Widget build(BuildContext context) {
    final listFranchise = Provider.of<List<Franchise>>(context);
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
          "List Franchise",
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
            onPressed: () => Navigator.of(context).pushNamed(FranchiseForm.id),
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
          (listFranchise != null)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: listFranchise.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 135,
                      child: Card(
                        elevation: 1,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                              FranchiseForm.id,
                              arguments: listFranchise[index]),
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
                                    image: AssetImage('assets/mcd.jpg'),
                                    /*image: CachedNetworkImageProvider(
                                        listFranchise[index].foto1),*/
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
                                                listFranchise[index].nama,
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
                                                    Icons.location_on,
                                                    color: accentColor,
                                                    size: smallSize,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    listFranchise[index].kota,
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
                                                    Icons.phone,
                                                    color: secondaryColor,
                                                    size: smallSize,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    listFranchise[index]
                                                        .whatsapp,
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
                                              Text(
                                                listFranchise[index].deskripsi,
                                                style: TextStyle(
                                                  fontFamily: primaryFont,
                                                  fontSize: tinySize,
                                                  color: primaryContentColor,
                                                ),
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
