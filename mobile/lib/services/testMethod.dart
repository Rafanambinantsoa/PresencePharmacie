import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.43.220:8000/api/';

class TestMethod {
  var client = http.Client();

  //get method
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
}
