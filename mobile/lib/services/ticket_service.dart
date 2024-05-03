import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.43.220:8000/api';

class BaseClient {
  var client = http.Client();

  //GET
  Future<dynamic> get(String api) async {
    var url = Uri.parse(baseUrl + api);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.get(url, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  //GET
  Future<dynamic> updateFirstPresence(String api) async {
    var url = Uri.parse(baseUrl + api);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(url, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
      //throw exception and catch it in UI
    }
  }

  //GET
  Future<dynamic> updateSecondPresence(String api) async {
    var url = Uri.parse(baseUrl + api);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.put(url, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
      //throw exception and catch it in UI
    }
  }

  // Mettre a jour le billets scanner
  Future<dynamic> updatebillet(String api) async {
    var url = Uri.parse(baseUrl + api);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(url, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    if (response.statusCode == 401) {
      return response.body;
    }
    if (response.statusCode == 409) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }
}
