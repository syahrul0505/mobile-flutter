import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final Uri _url = Uri.parse('https://saja-siji.jooal.pro');

  auth(data, apiURL) async {
    var fullUrl = _url.resolve(apiURL);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiURL) async {
    var fullUrl = _url.resolve(apiURL);
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  postData(data, apiURL) async {
    var fullUrl = _url.resolve(apiURL);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
