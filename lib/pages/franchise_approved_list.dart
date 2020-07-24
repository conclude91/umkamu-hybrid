import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/pages/franchise_form.dart';
import 'package:umkamu/utils/theme.dart';

class FranchiseApprovedList extends StatefulWidget {
  static const String id = "franchiseapprovedlist";

  @override
  _FranchiseApprovedListState createState() => _FranchiseApprovedListState();
}

class _FranchiseApprovedListState extends State<FranchiseApprovedList> {
  TextEditingController _filterController = new TextEditingController();
  String _access;
  String _id;
  List<Franchise> _listFranchise = [];
  List<Franchise> _filterListFranchise = [];

  @override
  void initState() {
    super.initState();
    _getPreferences();
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

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id') ?? '';
      _access = prefs.getString('access') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<Franchise>>(context) != null) {
      if (_access == 'Admin') {
        _listFranchise = Provider.of<List<Franchise>>(context)
            .where((franchise) => franchise.disetujui == 'Tidak')
            .toList();
      } else if (_access == 'Produsen') {
        _listFranchise = Provider.of<List<Franchise>>(context)
            .where((franchise) => franchise.pengusul == _id)
            .toList();
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'List Pengajuan Franchise',
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
          (_access == 'Admin' || _access == 'Produsen')
              ? IconButton(
                  icon: Icon(Icons.add, color: primaryContentColor),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(FranchiseForm.id),
                )
              : SizedBox(),
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
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            child: TextField(
              controller: _filterController,
              onChanged: _onFilterTextChanged,
              style: TextStyle(
                fontSize: tinySize,
                color: primaryContentColor,
                fontFamily: primaryFont,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Franchise apa yang kamu cari ?',
                prefixIcon: Icon(Icons.location_searching,
                    size: tinySize, color: primaryContentColor),
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
                  ? Expanded(
                      child: ListView.builder(
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
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      FranchiseForm.id,
                                      arguments: _filterListFranchise[index]);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 4,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(3),
                                                bottomLeft: Radius.circular(3),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            _filterListFranchise[
                                                                    index]
                                                                .foto1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Stack(
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          _filterListFranchise[
                                                                  index]
                                                              .nama,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                primaryFont,
                                                            fontSize: tinySize,
                                                            color:
                                                                primaryContentColor,
                                                            fontWeight:
                                                                fontBold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  accentColor,
                                                              size: microSize,
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
                                                                fontSize:
                                                                    microSize,
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
                                                              color:
                                                                  secondaryColor,
                                                              size: microSize,
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
                                                                fontSize:
                                                                    microSize,
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
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  primaryFont,
                                                              fontSize:
                                                                  microSize,
                                                              color:
                                                                  primaryContentColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: (_filterListFranchise[
                                                                    index]
                                                                .disetujui ==
                                                            'Ya')
                                                        ? Icon(
                                                            MdiIcons
                                                                .checkDecagram,
                                                            color: accentColor,
                                                            size: tinySize,
                                                          )
                                                        : Icon(
                                                            MdiIcons
                                                                .alertCircleOutline,
                                                            color: gold,
                                                            size: tinySize,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
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
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      FranchiseForm.id,
                                      arguments: _listFranchise[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(3),
                                            bottomLeft: Radius.circular(3),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        _listFranchise[index]
                                                            .foto1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Stack(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _listFranchise[index]
                                                          .nama,
                                                      style: TextStyle(
                                                        fontFamily: primaryFont,
                                                        fontSize: tinySize,
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
                                                          size: microSize,
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
                                                            fontSize: microSize,
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
                                                          size: microSize,
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
                                                            fontSize: microSize,
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              primaryFont,
                                                          fontSize: microSize,
                                                          color:
                                                              primaryContentColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: (_listFranchise[index]
                                                            .disetujui ==
                                                        'Ya')
                                                    ? Icon(
                                                        MdiIcons.checkDecagram,
                                                        color: accentColor,
                                                        size: tinySize,
                                                      )
                                                    : Icon(
                                                        MdiIcons
                                                            .alertCircleOutline,
                                                        color: gold,
                                                        size: tinySize,
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
                      ),
                    )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
