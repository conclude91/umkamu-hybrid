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
import 'package:umkamu/models/user.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/utils/theme.dart';
import 'package:umkamu/providers/franchise_provider.dart';
import 'package:umkamu/models/franchise.dart';

class UserForm extends StatefulWidget {
  static const String id = 'userform';
  final User user;

  UserForm(this.user);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _rekeningController = TextEditingController();
  final _poinController = TextEditingController();
  final _komisiController = TextEditingController();
  final _royaltyController = TextEditingController();
  var _tipeOptions = ['Konsumen', 'Produsen', 'Admin'];
  var _jenisKelaminOptions = ['Laki-Laki', 'Perempuan'];
  UserProvider _userProvider;
  List<Franchise> _listFranchise;
  FranchiseProvider _franchiseProvider;
  File _temp_file;
  final _picker = ImagePicker();
  String _access, _id;

  @override
  void initState() {
    super.initState();
    _getPreferences();
    Future.delayed(Duration.zero, () {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _franchiseProvider =
          Provider.of<FranchiseProvider>(context, listen: false);
      if (widget.user != null) {
        _namaController.text = widget.user.nama;
        _emailController.text = widget.user.email;
        _passwordController.text = widget.user.password;
        _whatsappController.text = widget.user.whatsapp;
        _rekeningController.text = widget.user.rekening;
        _poinController.text = widget.user.poin.toString();
        _komisiController.text = widget.user.komisi.toString();
        _royaltyController.text = widget.user.royalty.toString();
        _userProvider.user = widget.user;
      } else {
        _namaController.text = '';
        _emailController.text = '';
        _passwordController.text = '';
        _whatsappController.text = '';
        _rekeningController.text = '';
        _poinController.text = '0';
        _komisiController.text = '0';
        _royaltyController.text = '0';
        _userProvider.user = User();
        _userProvider.poin = 0;
        _userProvider.komisi = 0;
        _userProvider.royalty = 0;
        _userProvider.jenis_kelamin = 'Laki-Laki';
        _userProvider.tipe = 'Konsumen';
        _userProvider.leader = 'Tidak';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _whatsappController.dispose();
    _rekeningController.dispose();
    _poinController.dispose();
    _komisiController.dispose();
    _royaltyController.dispose();
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id') ?? '';
      _access = prefs.getString('access') ?? '';
    });
  }

  _getImageFile(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 500,
        maxHeight: 500,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
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
      imageCache.clear();
      _temp_file = croppedFile;
      _userProvider.temp_file = _temp_file.path;
    });
  }

  _showConfirmationAlert(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Notifikasi"),
        content: Text(
            "Apakah anda yakin akan menghapus data ini?\nData yang dihapus tidak bisa dipulihkan."),
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
              if (_userProvider.tipe == 'Produsen') {
                _franchiseProvider.remove(widget.user.id);
              }
              _userProvider.remove(widget.user.id);
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
      Navigator.pop(context);
      Navigator.pop(context); //pop dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_access == 'Admin' && _userProvider.tipe == 'Produsen') {
      _listFranchise = Provider.of<List<Franchise>>(context)
          .where((franchise) => franchise.id == _userProvider.id)
          .toList();
      if (_listFranchise.length == 1) {
        _franchiseProvider.foto1 = _listFranchise[0].foto1;
        _franchiseProvider.foto2 = _listFranchise[0].foto2;
        _franchiseProvider.foto3 = _listFranchise[0].foto3;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Pengguna',
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
              _userProvider.temp_file = null;
              Navigator.of(context).pop();
            }),
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/doodle-potrait.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CircleAvatar(
                    backgroundImage: (widget.user != null && _temp_file == null)
                        ? (widget.user.foto == 'assets/images/akun.jpg')
                            ? AssetImage(widget.user.foto)
                            : CachedNetworkImageProvider(widget.user.foto)
                        : _temp_file != null
                            ? AssetImage(_temp_file.path)
                            : AssetImage('assets/images/akun.jpg'),
                    radius: 75,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.image,
                        color: primaryContentColor,
                      ),
                      onPressed: () => _getImageFile(ImageSource.gallery),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.camera,
                        color: primaryContentColor,
                      ),
                      onPressed: () => _getImageFile(ImageSource.camera),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FormBuilder(
            key: _fbKey,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    controller: _namaController,
                    onChanged: (value) => _userProvider.nama = value,
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
                  FormBuilderDropdown(
                    attribute: 'jenis_kelamin',
                    onChanged: (value) =>
                        _userProvider.jenis_kelamin = value.toString(),
                    decoration: InputDecoration(
                      labelText: 'Jenis Kelamin',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    items: _jenisKelaminOptions
                        .map((jenis_kelamin) => DropdownMenuItem(
                            value: jenis_kelamin,
                            child: Text('$jenis_kelamin')))
                        .toList(),
                    initialValue: (widget.user != null)
                        ? widget.user.jenis_kelamin
                        : 'Laki-Laki',
                  ),
                  FormBuilderTextField(
                    controller: _emailController,
                    onChanged: (value) => _userProvider.email = value,
                    attribute: 'email',
                    maxLines: 1,
                    maxLength: 50,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _passwordController,
                    onChanged: (value) => _userProvider.password = value,
                    attribute: 'password',
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                    onChanged: (value) => _userProvider.whatsapp = value,
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
                  FormBuilderTextField(
                    controller: _rekeningController,
                    onChanged: (value) => _userProvider.rekening = value,
                    attribute: 'rekening',
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'Rekening',
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
                  (_access == 'Admin')
                      ? FormBuilderTextField(
                          controller: _poinController,
                          onChanged: (value) =>
                              _userProvider.poin = int.parse(value),
                          attribute: 'poin',
                          maxLines: 1,
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Poin',
                            labelStyle: TextStyle(
                              color: primaryContentColor,
                              fontSize: smallSize,
                              fontFamily: primaryFont,
                            ),
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.max(20000),
                            FormBuilderValidators.numeric(),
                          ],
                        )
                      : SizedBox(),
                  (_access == 'Admin')
                      ? FormBuilderTextField(
                          controller: _komisiController,
                          onChanged: (value) =>
                              _userProvider.komisi = int.parse(value),
                          attribute: 'komisi',
                          maxLines: 1,
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Komisi',
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
                        )
                      : SizedBox(),
                  (_access == 'Admin')
                      ? FormBuilderTextField(
                          controller: _royaltyController,
                          onChanged: (value) =>
                              _userProvider.royalty = int.parse(value),
                          attribute: 'royalty',
                          maxLines: 1,
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Royalty',
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
                        )
                      : SizedBox(),
                  (_access == 'Admin')
                      ? FormBuilderDropdown(
                          attribute: 'tipe',
                          onChanged: (value) =>
                              _userProvider.tipe = value.toString(),
                          decoration: InputDecoration(
                            labelText: 'Tipe',
                            labelStyle: TextStyle(
                              color: primaryContentColor,
                              fontSize: smallSize,
                              fontFamily: primaryFont,
                            ),
                          ),
                          validators: [FormBuilderValidators.required()],
                          items: _tipeOptions
                              .map((tipe) => DropdownMenuItem(
                                  value: tipe, child: Text('$tipe')))
                              .toList(),
                          initialValue: (widget.user != null)
                              ? widget.user.tipe
                              : 'Konsumen',
                        )
                      : SizedBox(),
                  (_access == 'Admin')
                      ? FormBuilderRadioGroup(
                          attribute: 'leader',
                          decoration: InputDecoration(labelText: 'Leader'),
                          onChanged: (value) =>
                              _userProvider.leader = value.toString(),
                          options: [
                            FormBuilderFieldOption(
                              value: 'Ya',
                            ),
                            FormBuilderFieldOption(
                              value: 'Tidak',
                            ),
                          ],
                          initialValue: (widget.user != null)
                              ? widget.user.leader
                              : 'Tidak',
                          validators: [FormBuilderValidators.required()],
                        )
                      : SizedBox(),
                ],
              ),
            ),
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
                    (_temp_file != null || widget.user != null)) {
                  _userProvider.save();
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
          (widget.user != null && _access == 'Admin' && _userProvider.id != _id)
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: MaterialButton(
                    color: primaryColor,
                    height: 50,
                    minWidth: double.infinity,
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
