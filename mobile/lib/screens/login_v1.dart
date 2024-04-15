import 'package:flutter/material.dart';
import 'package:mobile/models/api_response.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/screens/Dashboard.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/welcome.dart';
import 'package:mobile/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_v1 extends StatefulWidget {
  const Login_v1({super.key});

  @override
  State<Login_v1> createState() => _Login_v1State();
}

class _Login_v1State extends State<Login_v1> {
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
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // brightness: Brightness.light,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black,
        //     size: 20,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        //centrer le truc
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Text("Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.grey[700])),
                SizedBox(
                  height: 5,
                ),
                Text("Login to your account ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey[400])),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(children: <Widget>[
                makeInput(label: "Email", monController: txtEmail),
                SizedBox(
                  height: 5,
                ),
                makeInput(
                    label: "Password",
                    obcureText: true,
                    monController: txtPassword)
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
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
                  color: Colors.greenAccent,
                  onPressed: () {
                    loginUser();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text("Don't have an account ?"),
            //     Text(
            //       " Sign up",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

Widget makeInput({label, obcureText = false, monController}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: monController,
        obscureText: obcureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent))),
      )
    ],
  );
}
