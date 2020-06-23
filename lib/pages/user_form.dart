import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/user.dart';
import 'package:umkamu/providers/user_provider.dart';
import 'package:umkamu/utils/theme.dart';

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
  final _jenisKelaminController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _rekeningController = TextEditingController();
  final _poinController = TextEditingController();
  final _komisiController = TextEditingController();
  final _royaltyController = TextEditingController();
  var _tipeOptions = ['Customer', 'Member'];
  var _jenisKelaminOptions = ['Laki-Laki', 'Perempuan'];
  UserProvider _userProvider;
  File _foto;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      if (widget.user != null) {
        _namaController.text = widget.user.nama;
        _emailController.text = widget.user.email;
        _passwordController.text = widget.user.password;
        _whatsappController.text = widget.user.whatsapp;
        _rekeningController.text = widget.user.rekening;
        _poinController.text = widget.user.poin.toString();
        _komisiController.text = widget.user.komisi.toString();
        _royaltyController.text = widget.user.royalty.toString();
        _userProvider.setUser(widget.user);
      } else {
        _namaController.text = '';
        _emailController.text = '';
        _passwordController.text = '';
        _whatsappController.text = '';
        _rekeningController.text = '';
        _poinController.text = '0';
        _komisiController.text = '0';
        _royaltyController.text = '0';
        _userProvider.setUser(User());
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

  getImageFile(ImageSource source) async {
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
      _foto = croppedFile;
      _userProvider.setFoto(_foto.path);
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
          'User',
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
            initialValue: {},
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: widget.user != null
                        ? CachedNetworkImageProvider(widget.user.foto)
                        : _foto != null
                            ? AssetImage(_foto.path)
                            : AssetImage('assets/profile.jpg'),
                    radius: 75,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          color: primaryContentColor,
                        ),
                        onPressed: () => getImageFile(ImageSource.gallery),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera,
                          color: primaryContentColor,
                        ),
                        onPressed: () => getImageFile(ImageSource.camera),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: primaryLightContentColor,
                  ),
                  FormBuilderTextField(
                    controller: _namaController,
                    onChanged: (value) => _userProvider.setNama(value),
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
                      FormBuilderValidators.max(50),
                    ],
                  ),
                  FormBuilderDropdown(
                    attribute: 'jenis_kelamin',
                    onChanged: (value) => _userProvider.setJenisKelamin(value),
                    decoration: InputDecoration(
                      labelText: 'Jenis Kelamin',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [FormBuilderValidators.required()],
                    items: _jenisKelaminOptions
                        .map((jenis_kelamin) =>
                        DropdownMenuItem(value: jenis_kelamin, child: Text('$jenis_kelamin')))
                        .toList(),
                    initialValue:
                    (widget.user != null) ? widget.user.jenis_kelamin : 'Laki-Laki',
                  ),
                  FormBuilderTextField(
                    controller: _emailController,
                    onChanged: (value) => _userProvider.setEmail(value),
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
                      FormBuilderValidators.max(50),
                      FormBuilderValidators.email(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _passwordController,
                    onChanged: (value) => _userProvider.setPassword(value),
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
                      FormBuilderValidators.max(50),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _whatsappController,
                    onChanged: (value) => _userProvider.setWhatsapp(value),
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
                      FormBuilderValidators.max(15),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _rekeningController,
                    onChanged: (value) => _userProvider.setRekening(value),
                    attribute: 'rekening',
                    maxLines: 1,
                    maxLength: 15,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Rekening',
                      labelStyle: TextStyle(
                        color: primaryContentColor,
                        fontSize: smallSize,
                        fontFamily: primaryFont,
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.max(15),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _poinController,
                    onChanged: (value) => _userProvider.setPoin(int.parse(value)),
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
                      FormBuilderValidators.max(15),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _komisiController,
                    onChanged: (value) => _userProvider.setKomisi(int.parse(value)),
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
                      FormBuilderValidators.max(15),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _royaltyController,
                    onChanged: (value) => _userProvider.setRoyalty(int.parse(value)),
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
                      FormBuilderValidators.max(15),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                  FormBuilderDropdown(
                    attribute: 'tipe',
                    onChanged: (value) => _userProvider.setTipe(value),
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
                        .map((tipe) =>
                            DropdownMenuItem(value: tipe, child: Text('$tipe')))
                        .toList(),
                    initialValue:
                        (widget.user != null) ? widget.user.tipe : 'Customer',
                  ),
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
                _userProvider.saveUser();
                Navigator.of(context).pop();
                /*if (_fbKey.currentState.saveAndValidate()) {
                  print(_fbKey.currentState.value);
                }*/
              },
              height: 50,
              minWidth: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                _userProvider.removeUser(widget.user.id);
                Navigator.of(context).pop();
              },
              height: 50,
              minWidth: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
