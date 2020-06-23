import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/providers/franchise_provider.dart';
import 'package:umkamu/utils/theme.dart';

class FranchiseForm extends StatefulWidget {
  static const String id = 'franchiseform';
  final Franchise franchise;

  FranchiseForm(this.franchise);

  @override
  _FranchiseFormState createState() => _FranchiseFormState();
}

class _FranchiseFormState extends State<FranchiseForm> {
//  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _namaController = TextEditingController();
  final _kotaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _whatsappController = TextEditingController();

  FranchiseProvider _franchiseProvider;
  var _kategoriOptions = ['Jajanan', 'Oleh-Oleh', 'Antaran'];

  /*File _foto;
  final _picker = ImagePicker();*/

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _franchiseProvider =
          Provider.of<FranchiseProvider>(context, listen: false);
      if (widget.franchise != null) {
        _namaController.text = widget.franchise.nama;
        _kotaController.text = widget.franchise.kota;
        _deskripsiController.text = widget.franchise.deskripsi;
        _whatsappController.text = widget.franchise.whatsapp;
        _franchiseProvider.setFranchise(widget.franchise);
      } else {
        _namaController.text = '';
        _kotaController.text = '';
        _deskripsiController.text = '';
        _whatsappController.text = '';
        _franchiseProvider.setFranchise(Franchise());
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

  /*getImageFile(ImageSource source) async {
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
      _franchiseProvider.setFoto(_foto.path);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Franchise',
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
                  FormBuilderImagePicker(
                    attribute: 'images',
                    decoration: InputDecoration(
                      labelText: 'Foto',
                    ),
                    maxImages: 3,
                    iconColor: primaryColor,
                    // readOnly: true,
                    validators: [
                      FormBuilderValidators.required(),
                      (images) {
                        if (images.length < 2) {
                          return 'Two or more images required.';
                        }
                        return null;
                      }
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _namaController,
                    onChanged: (value) => _franchiseProvider.setNama(value),
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
                  FormBuilderTextField(
                    controller: _kotaController,
                    onChanged: (value) => _franchiseProvider.setKota(value),
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
                      FormBuilderValidators.max(50),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _deskripsiController,
                    onChanged: (value) =>
                        _franchiseProvider.setDeskripsi(value),
                    attribute: 'deskripsi',
                    maxLines: 5,
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
                      FormBuilderValidators.max(350),
                    ],
                  ),
                  FormBuilderTextField(
                    controller: _whatsappController,
                    onChanged: (value) => _franchiseProvider.setWhatsapp(value),
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
                  FormBuilderDropdown(
                    attribute: 'kategori',
                    onChanged: (value) => _franchiseProvider.setKategori(value),
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
                _franchiseProvider.saveFranchise();
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
                _franchiseProvider.removeFranchise(widget.franchise.id);
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
