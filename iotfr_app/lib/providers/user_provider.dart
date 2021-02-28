import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iotfr_app/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider {
  static const String URL = '192.168.18.68:4000';

  Future<dynamic> login(String username, String password) async {
    final _url = Uri.http(UserProvider.URL, '/user/login');
    final json = jsonEncode({"username": username, "password": password});
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

  Future<Map<String, dynamic>> crearUsuario(Usuario usuario) async {
    final _url = Uri.http(UserProvider.URL, '/user/add/');
    http.Response response = await http.post(_url,
        body: usuarioToJson(usuario),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        encoding: Encoding.getByName('utf-8'));
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded;
  }

  Future<Map<String, dynamic>> editarUsuario(Usuario usuario) async {
    final _url = Uri.http(UserProvider.URL, '/user/update/${usuario.id}');
    http.Response response = await http.put(_url,
        body: usuarioToJson(usuario),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        encoding: Encoding.getByName('utf-8'));
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded;
  }

  Future<Map<String, dynamic>> eliminarUsuario(Usuario usuario) async {
    final _url = Uri.http(UserProvider.URL, '/user/delete/${usuario.id}');
    http.Response response = await http.delete(
      _url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded;
  }

  Future<List<Usuario>> getUsuarios() async {
    final _url = Uri.http(UserProvider.URL, '/user/');
    http.Response response = await http.get(_url);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    List<Usuario> usuarios = List<Usuario>();
    if (decoded['status'] == 200) {
      final lista = decoded['usuarios'];
      for (var item in lista) usuarios.add(Usuario.fromJson(item));
    }
    return usuarios;
  }

  SharedPreferences _preferences;

  Future<void> setData(final Map<String, dynamic> data) async {
    _preferences = await SharedPreferences.getInstance();
    data.forEach((key, value) {
      if (value.runtimeType == bool) {
        _preferences.setBool(key, value);
      }
      if (value.runtimeType == String) {
        _preferences.setString(key, value);
      }
      if (value.runtimeType == int) {
        _preferences.setInt(key, value);
      }
    });
  }

  Future<Usuario> getUserData() async {
    _preferences = await SharedPreferences.getInstance();
    final keys = _preferences.getKeys();
    Map<String, dynamic> data = {};
    for (var key in keys) {
      data[key] = _preferences.get(key);
    }
    final usuario = Usuario.fromJson(data);

    return usuario;
  }

  Future<void> logout() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }
}
