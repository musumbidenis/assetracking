import 'dart:convert';
import 'package:http/http.dart' as http;

class CallAPi {
  final String _url = 'https://assetracking.musumbidenis.co.ke/api/';

  /*Posts data to database */
  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http
        .post(fullUrl, body: jsonEncode(data), headers: _setHeaders())
        .timeout(const Duration(seconds: 30));
  }

  /*Fetches data from database */
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
