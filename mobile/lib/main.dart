import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/screens/Dashboard.dart';
import 'package:mobile/screens/loading.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}
