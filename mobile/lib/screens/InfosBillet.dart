import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/NotifScan.dart';
import 'package:mobile/models/Ticket.dart';
import 'package:mobile/models/UserScanned.dart';
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
  String event = "Pharmacien non trouvé";
  int etat = 0;
  int prix = 0;
  String text = "Etat non trouvé";

  String firstname = "";
  String lastname = "";
  String email = "";
  int id = 0;
  String phone = "";

  String userId = "";
  String eventId = "";

  String kimChoice = "";
  String scanText = "Valider le premier scan";

  @override
  void initState() {
    super.initState();
    test();
  }

  void test() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString("userId")!;
      eventId = pref.getString("eventId")!;
      kimChoice = pref.getString("scanChoice")!;
      if (kimChoice == "2") {
        scanText = "Valider le deuxieme scan";
      }
    });

    var response =
        await BaseClient().get('/user/info/$userId').catchError((err) {});
    if (response != "") {
      var caster = UserScanned.fromJson(jsonDecode(response));
      debugPrint(response);
      setState(() {
        firstname = caster.firstname!;
        lastname = caster.lastname!;
        phone = caster.phone!;
        email = caster.email!;
        id = caster.id!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pharmacien non trouvé"),
        ),
      );
    }
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
          title: const Text('Infos Pharmacien'),
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
                        'Information Pharmacien',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(height: 1),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Firstname : $firstname  ",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Lastname : $lastname ',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Email : $email ',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Phone  : $phone',
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
                          // var scanId = pref.getString("scanChoice");
                          var scanChoice = pref.getString("scanChoice");
                          var eventId = pref.getString("eventId");

                          if (scanChoice == "1") {
                            var response = await BaseClient()
                                .updateFirstPresence(
                                    '/event/$eventId/firstScan/$id')
                                .catchError((err) {
                              print(err);
                            });
                            if (response == null) return;
                            var caster =
                                NotifScan.fromJson(jsonDecode(response));
                            String? top = caster.message;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(top),
                              ),
                            );
                            test();
                          } else {
                            var response = await BaseClient()
                                .updateSecondPresence(
                                    '/event/$eventId/secondScan/$id')
                                .catchError((err) {
                              print(err);
                            });
                            print(response);
                            if (response == null) return;
                            var caster =
                                NotifScan.fromJson(jsonDecode(response));
                            String? top = caster.message;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(top),
                              ),
                            );
                            test();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "$scanText",
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
                          onPressed: () => {
                            //redirect to back to DashBoard
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()),
                                (route) => false)
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
