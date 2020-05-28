import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class WhatsApp extends StatefulWidget {
  @override
  _WhatsAppState createState() => _WhatsAppState();
}

class _WhatsAppState extends State<WhatsApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: InkWell(child: const Text('Plugin example app'), onTap: (){
            Navigator.pop(context);
          },),
        ),
        body: Center(
            child: MaterialButton(
          onPressed: () {
            FlutterOpenWhatsapp.sendSingleMessage("+6285315399902", "Hello");
          },
          child: Text('Running on: $_platformVersion\n'),
        )),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
}
