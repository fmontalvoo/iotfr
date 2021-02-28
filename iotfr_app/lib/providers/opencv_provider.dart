import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenCVProvider{
  static const String URL = '192.168.18.68:4001';

  Future<dynamic> registerFaces(String nombre, String apellido) async {
    final _url = Uri.http(OpenCVProvider.URL, '/register/faces');
    final json = jsonEncode({"nombre": nombre, "apellido": apellido});
    http.Response response = await http.post(_url,
        body: json,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        encoding: Encoding.getByName('utf-8'));
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded;
  }
}