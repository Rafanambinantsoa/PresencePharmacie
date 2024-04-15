import 'package:flutter/material.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/screens/Dashboard.dart';
import 'package:mobile/screens/login_v1.dart';
import 'package:mobile/screens/welcome.dart';
import 'package:mobile/services/user_service.dart';

import '../constant.dart';
import 'home.dart';
import 'login.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void loadUserInfo() async {
    String token = await getToken();
    if (token != null) {
      ApiResponse res = await getUserDetail();
      if (res.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login_v1()),
            (route) => false);
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login_v1()),
          (route) => false);
    }
  }

  @override
  void initState() {
    loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }
}
