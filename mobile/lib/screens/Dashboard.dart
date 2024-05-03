import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/Components/cardDash.dart';
import 'package:mobile/Components/cardScan.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/screens/EventList.dart';
import 'package:mobile/screens/login_v1.dart';
import 'package:mobile/services/MethodScan.dart';
import 'package:mobile/services/user_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userName = '';
  int id = 0;
  var getResult = "";

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
        id = (userApiResponse.data as User).id ?? 0;
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
      appBar: AppBar(
        leading: IconButton(
          // Bouton pour afficher le nom de l'utilisateur
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Bienvenue ,  "),
                  content: Text(userName),
                );
              },
            );
          },
          icon: Icon(Icons.account_circle),
        ),
        title: Text('Dashboard'),
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
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            //Icons button wiht text begin scan ticket
            GestureDetector(
              onTap: () => {
                Get.to(() => EventList(
                      id: "1",
                    ))
              },
              child: const VersScan(
                icon: Icons.qr_code_scanner,
                text: "Premier  Scan",
              ),
            ),
            GestureDetector(
              onTap: () => {
                Get.to(() => EventList(
                      id: "2",
                    ))
              },
              child: const VersScan(
                icon: Icons.qr_code_scanner,
                text: "Deuxième Scan",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
