import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/providers/franchise_provider.dart';
import 'package:umkamu/utils/theme.dart';

class NewFranchiseForm extends StatefulWidget {
  static const String id = 'franchiseform';
  final Franchise franchise;

  NewFranchiseForm(this.franchise);

  @override
  _NewFranchiseFormState createState() => _NewFranchiseFormState();
}

class _NewFranchiseFormState extends State<NewFranchiseForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _namaController = TextEditingController();
  final _kotaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _whatsappController = TextEditingController();
  FranchiseProvider _franchiseProvider;
  var _kategoriOptions = ['Jajanan', 'Oleh-Oleh', 'Antaran'];
  File _temp_file1, _temp_file2, _temp_file3;
  final _picker = ImagePicker();
  String _idUser;
  String _access;

  @override
  void initState() {
    super.initState();
    _getPreferences();
    Future.delayed(Duration.zero, () {
      _franchiseProvider =
          Provider.of<FranchiseProvider>(context, listen: false);
      _franchiseProvider.temp_file1 = null;
      _franchiseProvider.temp_file2 = null;
      _franchiseProvider.temp_file3 = null;
      if (widget.franchise != null) {
        _namaController.text = widget.franchise.nama;
        _kotaController.text = widget.franchise.kota;
        _deskripsiController.text = widget.franchise.deskripsi;
        _whatsappController.text = widget.franchise.whatsapp;
        _franchiseProvider.franchise = widget.franchise;
      } else {
        _namaController.text = '';
        _kotaController.text = '';
        _deskripsiController.text = '';
        _whatsappController.text = '';
        _franchiseProvider.franchise = Franchise();
        _franchiseProvider.kategori = 'Jajanan';
        _franchiseProvider.id = DateTime.now().millisecondsSinceEpoch.toString();
        _franchiseProvider.promo = 'Tidak';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
    _kotaController.dispose();
    _deskripsiController.dispose();
    _whatsappController.dispose();
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _access = prefs.getString('access') ?? '';
      _idUser = prefs.getString('id') ?? '';
    });
  }

  _getImageFile1(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1000,
        maxHeight: 500,
        aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Foto',
            toolbarColor: backgroundColor,
            toolbarWidgetColor: primaryContentColor,
            statusBarColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Edit Foto',
        ));
    setState(() {
      _temp_file1 = croppedFile;
      _franchiseProvider.temp_file1 = _temp_file1.path;
    });
  }

  _getImageFile2(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1000,
        maxHeight: 500,
        aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Foto',
            toolbarColor: backgroundColor,
            toolbarWidgetColor: primaryContentColor,
            statusBarColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Edit Foto',
        ));
    setState(() {
      _temp_file2 = croppedFile;
      _franchiseProvider.temp_file2 = _temp_file2.path;
    });
  }

  _getImageFile3(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 1000,
        maxHeight: 500,
        aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Foto',
            toolbarColor: backgroundColor,
            toolbarWidgetColor: primaryContentColor,
            statusBarColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Edit Foto',
        ));
    setState(() {
      _temp_file3 = croppedFile;
      _franchiseProvider.temp_file3 = _temp_file3.path;
    });
  }

  _showConfirmationAlert(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Hapus Data Ini ?"),
        content: Text("Data yang dihapus tidak bisa dipulihkan."),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("Batalkan"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text("Hapus"),
            onPressed: () {
              _franchiseProvider.remove(widget.franchise.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SpinKitDoubleBounce(
          color: secondaryContentColor,
          size: 50.0,
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      _franchiseProvider.temp_file1 = null;
      _franchiseProvider.temp_file2 = null;
      _franchiseProvider.temp_file3 = null;
      Navigator.pop(context);
      Navigator.pop(context); //pop dialog
    });
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
          (_access == 'Admin') ? 'Franchise' : 'Franchise-Ku',
          style: TextStyle(
            color: primaryContentColor,
            fontSize: mediumSize,
            fontFamily: primaryFont,
            fontWeight: fontBold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryContentColor),
          onPressed: () {
            _franchiseProvider.temp_file1 = null;
            _franchiseProvider.temp_file2 = null;
            _franchiseProvider.temp_file3 = null;
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          child: Container(
            color: shadow,
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
      ),
      body: ListView(
        children: <Widget>[
          FormBuilder(
            key: _fbKey,
            initialValue: {},
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Foto 1 : ',
                          style: TextStyle(
                              fontFamily: primaryFont,
                              color: primaryContentColor,
                              fontSize: smallSize),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (widget.franchise != null &&
                                        _temp_file1 == null)
                                    ? CachedNetworkImageProvider(
                                        widget.franchise.foto1)
                                    : (_temp_file1 != null)
                                        ? AssetImage(_temp_file1.path)
                                        : AssetImage('assets/images/photo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          onTap: () => _getImageFile1(ImageSource.gallery),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Foto 2 : ',
                          style: TextStyle(
                              fontFamily: primaryFont,
                              color: primaryContentColor,
                              fontSize: smallSize),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (widget.franchise != null &&
                                        _temp_file2 == null)
                                    ? CachedNetworkImageProvider(
                                        widget.franchise.foto2)
                                    : (_temp_file2 != null)
                                        ? AssetImage(_temp_file2.path)
                                        : AssetImage('assets/images/photo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          onTap: () => _getImageFile2(ImageSource.gallery),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Foto 3 : ',
                          style: TextStyle(
                              fontFamily: primaryFont,
                              color: primaryContentColor,
                              fontSize: smallSize),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (widget.franchise != null &&
                                        _temp_file3 == null)
                                    ? CachedNetworkImageProvider(
                                        widget.franchise.foto3)
                                    : (_temp_file3 != null)
                                        ? AssetImage(_temp_file3.path)
                                        : AssetImage('assets/images/photo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          onTap: () => _getImageFile3(ImageSource.gallery),
                        ),
                      ],
                    ),
                  ),
                  FormBuilderTextField(
                    controller: _namaController,
                    onChanged: (value) => _franchiseProvider.nama = value,
                    attribute: 'nama',
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontFamily: primaryFont,
                        fontSize: smallSize,
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _kotaController,
                    onChanged: (value) => _franchiseProvider.kota = value,
                    attribute: 'kota',
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Kota',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _deskripsiController,
                    onChanged: (value) => _franchiseProvider.deskripsi = value,
                    attribute: 'deskripsi',
                    maxLines: 7,
                    maxLength: 350,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _whatsappController,
                    onChanged: (value) => _franchiseProvider.whatsapp = value,
                    attribute: 'whatsapp',
                    maxLines: 1,
                    maxLength: 15,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'WhatsApp',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                  FormBuilderDropdown(
                    attribute: 'kategori',
                    onChanged: (value) => _franchiseProvider.kategori = value,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [FormBuilderValidators.required()],
                    items: _kategoriOptions
                        .map((kategori) => DropdownMenuItem(
                            value: kategori, child: Text('$kategori')))
                        .toList(),
                    initialValue: (widget.franchise != null)
                        ? widget.franchise.kategori
                        : 'Jajanan',
                  ),
                  _access == 'Admin'
                      ? FormBuilderRadioGroup(
                          attribute: 'promo',
                          decoration: InputDecoration(labelText: 'Promo'),
                          onChanged: (value) =>
                              _franchiseProvider.promo = value.toString(),
                          options: [
                            FormBuilderFieldOption(
                              value: 'Ya',
                            ),
                            FormBuilderFieldOption(
                              value: 'Tidak',
                            ),
                          ],
                          initialValue: (widget.franchise != null)
                              ? widget.franchise.promo
                              : 'Tidak',
                          validators: [FormBuilderValidators.required()],
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: MaterialButton(
              color: secondaryColor,
              child: Text(
                'Simpan',
                style: TextStyle(
                  fontFamily: primaryFont,
                  fontSize: smallSize,
                  color: secondaryContentColor,
                ),
              ),
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate() &&
                    ((_temp_file1 != null &&
                            _temp_file2 != null &&
                            _temp_file3 != null) ||
                        widget.franchise != null)) {
                  _franchiseProvider.save();
                  _onLoading();
                } else {
                  print(_fbKey.currentState.value);
                  Fluttertoast.showToast(
                      msg: 'Inputan data belum lengkap',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: primaryContentColor.withOpacity(0.5),
                      textColor: secondaryContentColor,
                      fontSize: tinySize);
                }
              },
              height: 50,
              minWidth: double.infinity,
            ),
          ),
          (widget.franchise != null && _access == 'Admin')
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: MaterialButton(
                    color: primaryColor,
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontFamily: primaryFont,
                        fontSize: smallSize,
                        color: secondaryContentColor,
                      ),
                    ),
                    onPressed: () {
                      _showConfirmationAlert(context);
                    },
                    height: 50,
                    minWidth: double.infinity,
                  ),
                )
              : SizedBox(
                  height: 5,
                ),
        ],
      ),
    );
  }
}
