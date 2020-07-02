import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
import 'package:umkamu/models/franchise.dart';
import 'package:umkamu/providers/franchise_provider.dart';
import 'package:umkamu/utils/theme.dart';
import 'package:http/http.dart' show get;

class FranchiseDetail extends StatefulWidget {
  static const String id = 'franchisedetail';
  final Franchise franchise;

  FranchiseDetail(this.franchise);

  @override
  _FranchiseDetailState createState() => _FranchiseDetailState();
}

class _FranchiseDetailState extends State<FranchiseDetail> {
  int _current = 0;
  FranchiseProvider _franchiseProvider;
  double _screenWidth, _screenHeight;
  Size _size;
  String imageData;
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _franchiseProvider = Provider.of<FranchiseProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _getFileFromURL(String url) async {
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/temp";
    var filePathAndName = documentDirectory.path + '/temp/file';
    await Directory(firstPath).create(recursive: true);
    File file = new File(filePathAndName);
    file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      imageData = filePathAndName;
      dataLoaded = true;
    });
    return imageData;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _screenWidth = _size.width;
    _screenHeight = _size.height;

    return Scaffold(
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
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 50),
            children: <Widget>[
              SizedBox(
                height: 200,
                width: _screenWidth,
                child: Carousel(
                  images: [
                    NetworkImage(
                        'https://non-indonesia-distribution.brta.in/2019-01/36c49e263ba2607cf4ff29c9b7739075bf595128.jpg'),
                    NetworkImage(
                        'https://balitribune.co.id/sites/default/files/styles/xtra_large/public/field/image/Orang%20Eropa%20Doyan%20Makanan%20Indonesia.jpg?itok=KhyFFbAs'),
                    NetworkImage(
                        'https://blog.cakap.com/wp-content/uploads/2019/03/food-feature.jpg'),
                    //ExactAssetImage("assets/images/LaunchImage.jpg")
                  ],
                  dotSize: 3.0,
                  dotSpacing: 15.0,
                  dotColor: secondaryContentColor,
                  indicatorBgPadding: 5.0,
                  dotBgColor: transparent,
                  borderRadius: true,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Rumah Makan Nyampleng',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryContentColor,
                        fontSize: largeSize,
                        fontFamily: primaryFont,
                        fontWeight: fontBold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: smallSize,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Malang',
                        style: TextStyle(
                          color: primaryContentColor,
                          fontSize: smallSize,
                          fontFamily: primaryFont,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 25,
                    width: _screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          child: Image(
                            image: NetworkImage(
                                'https://infiny.co.id/img/logo/facebook.png'),
                          ),
                          onTap: () async {
                            SocialShare.shareFacebookStory(
                                await _getFileFromURL('https://firebasestorage.googleapis.com/v0/b/umkamu-b4a41.appspot.com/o/franchise%2Ffoto%2F1593375516616_foto1?alt=media&token=00aa2b89-5204-4e61-b388-eb7a8cd00c7b'),
                                primaryColorHex,
                                primaryColorHex,
                                'https://pub.dev/packages/image_downloader',
                                appId: '292360518665049');
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          child: Image(
                            image: NetworkImage(
                                'https://pluspng.com/img-png/instagram-png-instagram-png-logo-1455.png'),
                          ),
                          onTap: () async {
                            PickedFile pickedFile = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            SocialShare.shareInstagramStory(
                                    pickedFile.path,
                                    primaryColorHex,
                                    primaryColorHex,
                                    'https://api.whatsapp.com/send?phone=15551234567')
                                .then((data) {
                              print(data);
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          child: Image(
                            image: NetworkImage(
                                'https://cdn4.iconfinder.com/data/icons/social-media-icons-the-circle-set/48/twitter_circle-512.png'),
                          ),
                          onTap: () async {
                            SocialShare.shareSms(
                                    "This is Social Share Sms example",
                                    url: "\nhttps://google.com/",
                                    trailingText: "\nhello")
                                .then((data) {
                              print(data);
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          child: Image(
                            image: NetworkImage(
                                'https://pngimg.com/uploads/whatsapp/whatsapp_PNG21.png'),
                          ),
                          onTap: () {
                            SocialShare.shareWhatsapp(
                                    "Hello World \n https://google.com")
                                .then((data) {
                              print(data);
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(
                color: primaryLightContentColor,
                thickness: 0.5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text:
                        'Rumah makan \"Nyampleng\" TERLETAK di sebelah selatan alun-alun Kota Malang. Rumah makan ini TERKENAL dengan masakan tradisionalnya. Nama rumah makan ini BERASAL dari bahasa Jawa yaitu nyamleng yang berarti enak sekali. Sesuai dengan namanya rumah makan ini menyediakan masakan Jawa dengan cita rasa tinggi. Bangunan rumah makan ini beraksitektur Jawa. HAMPIR semua peralatan dan ornamen di rumah makan ini BERHIASKAN dengan nuansa Jawa.'
                        '\n\nMemasuki rumah makan ini, kita disambut gapura bernuansa Jawa yang berdiri kokoh di pintu masuk. Di bagian DEPAN rumah makan ini terpasang gapura yang indah bertuliskan huruf Jawa dengan warna alami. Begitu memasuki pintu utama kita akan disambut ruangan yang sejuk dengan estetika tinggi. Lantai rumah makan ini terbuat dari kayu berwarna coklat tua. Dinding berwarna putih bersih. Hiasan etnik Jawa ditata melengkung INDAH di SETIAP dinding ruangan. Warna keemasan dipilih untuk menunjukkan kebesaran tempat ini. Hiasan batik sogan yang MENEMPEL pada bagian DALAM dinding menambah kekentalan suasana tradisi Jawa.'
                        '\n\nDi DALAM rumah makan ini diletakkan gamelan Jawa yang tertata rapi lengkap dengan niyaganya. Warna gamelan keemasan dengan bingkai kayu warna coklat gelap sangat ANTIK dan MENARIK. Di samping gamelan di tata meja kursi antik dengan warna legam. Di pojok ruangan diletakkan lampu hias coklat dengan ornamen kuning keemasan.'
                        '\n\nDi bagian BELAKANG terdapat kolam ikan nila. Warna merah yang mendominasi kolam nampak seperti kain indah yang sedang dimainkan seorang penari. Kolam itu tidak terlalu luas, tetapi BERSIH. Di pinggir kolam dihias beragam bunga. Warna warni bunga dengan SEMERBAK wanginya menambah keasrian rumah makan ini.'
                        '\n\nAroma gorengan tempe merambah semua ruangan. Gurihnya aroma tempe tergambar dari bau yang ditimbulkannya. AROMA sambal terasinya juga merangsang orang segera mencicipinya. Alunan lagu Jawa yang syahdu menambah SELERA penyet tempe yang telah dihidangkan di atas meja.',
                    style: TextStyle(
                      color: primaryContentColor,
                      fontSize: microSize,
                      fontFamily: primaryFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              color: transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 5,
                    child: Material(
                      color: primaryColor,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            'Berminat',
                            style: TextStyle(
                                fontSize: tinySize,
                                fontFamily: primaryFont,
                                color: secondaryContentColor,
                                fontWeight: fontBold),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.5,
                    child: Container(
                      color: secondaryContentColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 5,
                    child: Material(
                      color: primaryColor,
                      child: InkWell(
                        child: Center(
                          child: Text(
                            'Konsultasi',
                            style: TextStyle(
                                color: secondaryContentColor,
                                fontSize: tinySize,
                                fontFamily: primaryFont,
                                fontWeight: fontBold),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
