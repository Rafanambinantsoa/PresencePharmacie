import 'package:flutter/material.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/services/user_service.dart';

import '../models/user.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      appBar: AppBar(
        title: Text('EventPass , $userName'),
        actions: [
          IconButton(
              onPressed: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Login()),
                          (route) => false),
                    });
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        child: Text("BLffsfs"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: " "),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: " "),
        ]),
      ),
    );
  }
}
