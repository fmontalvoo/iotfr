import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iotfr_app/models/historial.dart';

class HistoryProvider {
  static const String URL = '192.168.18.68:4000';

  Future<List<Historial>> getHistorial() async {
    final _url = Uri.http(HistoryProvider.URL, '/history/');
    http.Response response = await http.get(_url);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    List<Historial> historial = List<Historial>();
    if (decoded['status'] == 200) {
      final lista = decoded['historial'];
      for (var item in lista) historial.add(Historial.fromJson(item));
    }
    return historial;
  }
}
