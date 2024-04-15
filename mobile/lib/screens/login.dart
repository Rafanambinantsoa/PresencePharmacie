import 'package:flutter/material.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void loginUser() async {
    ApiResponse res = await login(txtEmail.text, txtPassword.text);
    if (res.error == null) {
      saveAndRedirectHome(res.data as User);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${res.error}'),
        ),
      );
    }
  }

  void saveAndRedirectHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(10, 14, 10, 10),
          children: [
            SizedBox(height: 60),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'Invalid Email Adresse' : null,
              decoration: kInputDecoration("Email"),
            ),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: txtPassword,
              obscureText: true,
              validator: (val) => val!.isEmpty ? 'Mot de passe requis' : null,
              decoration: kInputDecoration("password"),
            ),
            SizedBox(height: 30),
            TextButton(
              child: Text('Login', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
                padding: MaterialStateProperty.resolveWith(
                    (states) => EdgeInsets.symmetric(vertical: 14)),
              ),
              onPressed: () => {
                if (formKey.currentState!.validate()) {loginUser()}
              },
            )
          ],
        ),
      ),
    );
  }
}
