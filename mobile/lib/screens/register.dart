import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            //centrer le truc
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Registration",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.grey[700])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Login to your account ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey[400])),
                  ],
                ),
                Column(children: <Widget>[
                  makeInput(label: "Name"),
                  SizedBox(
                    height: 10,
                  ),
                  makeInput(label: "Email"),
                  SizedBox(
                    height: 10,
                  ),
                  makeInput(label: "Confirm Password", obcureText: true),
                ]),
                SizedBox(
                  height: 35,
                ),
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
                    color: Colors.greenAccent,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'Register me',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account ?"),
                    Text(
                      " Sign in",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

Widget makeInput({label, obcureText = false}) {
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
