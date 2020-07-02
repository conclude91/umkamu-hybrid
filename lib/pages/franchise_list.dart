import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/pages/franchise_form.dart';
import 'package:umkamu/utils/theme.dart';

import 'franchise_detail.dart';

class FranchiseList extends StatefulWidget {
  static const String id = "franchiselist";

  @override
  _FranchiseListState createState() => _FranchiseListState();
}

class _FranchiseListState extends State<FranchiseList> {
  TextEditingController _filterController = new TextEditingController();
  String _filter;
  List<Franchise> _listFranchise;
  List<Franchise> _filterListFranchise = [];
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
    _filterListFranchise.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _listFranchise.forEach((franchise) {
      if (franchise.nama.toLowerCase().contains(text.toLowerCase()) ||
          franchise.id.toLowerCase().contains(text.toLowerCase()) ||
          franchise.kota.toLowerCase().contains(text.toLowerCase()) ||
          franchise.whatsapp.toLowerCase().contains(text.toLowerCase())) {
        _filterListFranchise.add(franchise);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _listFranchise = Provider.of<List<Franchise>>(context);
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
                hintText: 'Franchise apa yang kamu cari ?',
                prefixIcon: Icon(Icons.location_searching,
                    size: smallSize, color: primaryContentColor),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: shadow,
            ),
          ),
          (_listFranchise != null)
              ? (_filterListFranchise.length != 0 ||
                      _filterController.text.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filterListFranchise.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 135,
                          child: Card(
                            elevation: 1,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: InkWell(
                              /*onTap: () => Navigator.of(context).pushNamed(
                                  FranchiseForm.id,
                                  arguments: _filterListFranchise[index]),*/
                              onTap: () => Navigator.of(context).pushNamed(
                                  FranchiseDetail.id,
                                  arguments: _filterListFranchise[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      child: Container(
                                        width: 165,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              _filterListFranchise[index]
                                                  .foto1),
                                          fit: BoxFit.cover,
                                        ),
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
                                                    _listFranchise[index].nama,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: smallSize,
                                                      color:
                                                          primaryContentColor,
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
                                                        _filterListFranchise[
                                                                index]
                                                            .kota,
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
                                                        size: smallSize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _filterListFranchise[
                                                                index]
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
                                                  Flexible(
                                                    child: Text(
                                                      _filterListFranchise[
                                                              index]
                                                          .deskripsi,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: primaryFont,
                                                        fontSize: tinySize,
                                                        color:
                                                            primaryContentColor,
                                                      ),
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
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listFranchise.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 135,
                          child: Card(
                            elevation: 1,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: InkWell(
                              /*onTap: () => Navigator.of(context).pushNamed(
                                  FranchiseForm.id,
                                  arguments: _listFranchise[index]),*/
                              onTap: () => Navigator.of(context).pushNamed(
                                  FranchiseDetail.id,
                                  arguments: _listFranchise[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      child: Container(
                                        width: 165,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              _listFranchise[index].foto1),
                                          fit: BoxFit.cover,
                                        ),
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
                                                    _listFranchise[index].nama,
                                                    style: TextStyle(
                                                      fontFamily: primaryFont,
                                                      fontSize: smallSize,
                                                      color:
                                                          primaryContentColor,
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
                                                        _listFranchise[index]
                                                            .kota,
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
                                                        size: smallSize,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        _listFranchise[index]
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
                                                  Flexible(
                                                    child: Text(
                                                      _listFranchise[index]
                                                          .deskripsi,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: primaryFont,
                                                        fontSize: tinySize,
                                                        color:
                                                            primaryContentColor,
                                                      ),
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
