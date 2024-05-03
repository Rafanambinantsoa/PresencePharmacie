import 'package:flutter/material.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/login_v1.dart';
import 'package:mobile/screens/qrScanner.dart';
import 'package:mobile/screens/register.dart';
import 'package:mobile/services/user_service.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String userName = ''; // Variable pour stocker le nom de l'utilisateur

  @override
  void initState() {
    super.initState();
    fetchUserDetails(); // Appel à la fonction pour récupérer les détails de l'utilisateur
  }

  void fetchUserDetails() async {
    ApiResponse userApiResponse = await getUserDetail();

    if (userApiResponse.data != null) {
      setState(() {
        // userName = "kil";
        userName = (userApiResponse.data as User).name ?? '';
      });
    } else {
      setState(() {
        userName = "nope";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Viens le bienvenus, $userName ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'BIenvenus dans EventPass ici vous etes le scanner de billets des événements',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/welcome.png'))),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 40,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login_v1()));
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Scanner un Qr',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 40,
                      color: Colors.yellow,
                      onPressed: () {
                        logout().then((value) => {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Login_v1()),
                                  (route) => false),
                            });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Se deconnecter',
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
