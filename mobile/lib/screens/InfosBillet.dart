import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/Ticket.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/models/resultatScan.dart';
import 'package:mobile/screens/Dashboard.dart';
import 'package:mobile/screens/login_v1.dart';
import 'package:mobile/screens/qrScanner.dart';
import 'package:mobile/services/MethodScan.dart';
import 'package:mobile/services/ticket_service.dart';
import 'package:mobile/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfosBillet extends StatefulWidget {
  const InfosBillet({super.key});

  @override
  State<InfosBillet> createState() => _InfosBilletState();
}

class _InfosBilletState extends State<InfosBillet> {
  String event = "Evenement non trouvé";
  int etat = 0;
  int prix = 0;
  String text = "Etat non trouvé";

  String maitre = "";
  @override
  void initState() {
    super.initState();
    test();
  }

  void test() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      maitre = pref.getString("billets")!;
    });
    var response =
        await BaseClient().get('/ticketInfo/$maitre').catchError((err) {});
    if (response == null) return;
    var caster = Ticket.fromJson(jsonDecode(response));
    debugPrint(response);
    setState(() {
      event = caster.title!;
      etat = caster.isScanned!;
      prix = caster.prix!;
      text = caster.scannedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            // Bouton pour afficher le nom de l'utilisateur
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Infos du Billet'),
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
              onPressed: () {
                logout();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login_v1()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Column(
                    children: <Widget>[
                      Text(
                        'Voici les Infos du Billets',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(height: 1),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Evenement : $event  ",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Prix : $prix Ar',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Etat  : $text',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 40,
                        onPressed: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          var idbillet = pref.getString("billets");
                          var userid = pref.getInt("userId");
                          var user = {
                            "idOrgan": userid,
                          };

                          var response = await BaseClient()
                              .updatebillet('/scanMe/$idbillet', user)
                              .catchError((err) {});
                          if (response == null) return;
                          var explose = Scan.fromJson(jsonDecode(response));
                          String? top = explose.message;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(top!),
                            ),
                          );
                          test();
                          // debugPrint(explose.message);
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          'Valider le Billets',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 40,
                          color: const Color.fromRGBO(255, 235, 59, 1),
                          onPressed: () async {
                            await GestionScanner(context).scanqrCode();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            'Retour vers une autre Scan',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ));
  }
}
