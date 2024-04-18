import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile/screens/InfosBillet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class qrScanner extends StatefulWidget {
  const qrScanner({super.key, required this.id});

  @override
  State<qrScanner> createState() => _qrScannerState();
  final String id;
}

class _qrScannerState extends State<qrScanner> {
  late String _eventId;

  var getResult = "";
  void redirectMe(idao) async {
    if (idao != "") {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("userId", idao);
      pref.setString("eventId", _eventId);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => InfosBillet()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _eventId = widget.id.toString();
    print(_eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Espace Scan des Billets ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/scan.jpg'))),
                  ),
                  Column(
                    children: <Widget>[
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 40,
                        onPressed: () {
                          scanqrCode();
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Commencer le scan',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          Text(
                            getResult,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 19),
                          ),
                        ],
                      ),
                    ],
                  )
                ]),
          ),
        ));
  }

  void scanqrCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Annuler", true, ScanMode.QR);
      if (!mounted) return;

      setState(() {
        redirectMe(qrCode);
      });
    } on PlatformException {
      getResult = "Failed to scan ";
    }
  }
}
