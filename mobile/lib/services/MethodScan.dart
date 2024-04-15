import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile/screens/InfosBillet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestionScanner {
  BuildContext context; // Le contexte de votre application

  GestionScanner(this.context);

  Future<void> redirectMe(String idao) async {
    if (idao != "") {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("billets", idao);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const InfosBillet()),
        (route) => false,
      );
    }
  }

  Future<void> scanqrCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Annuler",
        true,
        ScanMode.QR,
      );
      if (!mounted) return;

      await redirectMe(qrCode);
    } on PlatformException {
      print("Failed to scan ");
    }
  }

  bool get mounted {
    // Assurez-vours que votre logique pour vérifier si le widget est toujours monté soit correcte
    // Par exemple, si vous avez un Stateful widget, vous pouvez vérifier si mounted est true/false
    // Votre implémentation de cette logique dépend de la structure de votre application
    return true; // Mettez votre logique de vérification ici
  }
}
