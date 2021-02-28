import 'package:flutter/material.dart';

import 'package:iotfr_app/models/historial.dart';

import 'package:iotfr_app/providers/history_provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _historyProvider = HistoryProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: SingleChildScrollView(child: _table(context)),
    );
  }

  Widget _table(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FutureBuilder(
              future: _historyProvider.getHistorial(),
              builder: (context, AsyncSnapshot<List<Historial>> snapshot) {
                if (!snapshot.hasData || snapshot.hasError)
                  return CircularProgressIndicator();
                return DataTable(columns: <DataColumn>[
                  DataColumn(label: Text('ID'), numeric: true),
                  DataColumn(label: Text('Nombre y Apellido')),
                  DataColumn(label: Text('Fecha')),
                ], rows: _filas(context, snapshot.data));
              }),
        ),
      ],
    );
  }

  List<DataRow> _filas(BuildContext context, List<Historial> historial) {
    final _filas = List<DataRow>();
    for (var registro in historial) {
      _filas.add(DataRow(cells: [
        DataCell(Text('${registro.id}')),
        DataCell(Text(registro.nombreApellido)),
        DataCell(Text(registro.fecha)),
      ]));
    }
    return _filas;
  }
}
