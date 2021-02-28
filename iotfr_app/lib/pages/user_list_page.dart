import 'package:flutter/material.dart';
import 'package:iotfr_app/models/usuario.dart';

import 'package:iotfr_app/providers/user_provider.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final UserProvider _userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de usuarios'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: _table(context),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _table(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FutureBuilder(
              future: _userProvider.getUsuarios(),
              builder: (context, AsyncSnapshot<List<Usuario>> snapshot) {
                if (!snapshot.hasData || snapshot.hasError)
                  return CircularProgressIndicator();
                return DataTable(columns: <DataColumn>[
                  DataColumn(label: Text('ID'), numeric: true),
                  DataColumn(label: Text('Usuario')),
                  DataColumn(label: Text('Nombres')),
                  DataColumn(label: Text('Apellidos')),
                  DataColumn(label: Text('Operaciones'))
                ], rows: _filas(context, snapshot.data));
              }),
        ),
      ],
    );
  }

  List<DataRow> _filas(BuildContext context, List<Usuario> usuarios) {
    final _filas = List<DataRow>();
    for (var usuario in usuarios) {
      _filas.add(DataRow(cells: [
        DataCell(Text('${usuario.id}')),
        DataCell(Text(usuario.username)),
        DataCell(Text(usuario.nombres)),
        DataCell(Text(usuario.apellidos)),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, 'user',
                            arguments: {'usuario': usuario});
                      })),
              SizedBox(width: 15),
              Flexible(
                  child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _userProvider.eliminarUsuario(usuario);
                        setState(() {});
                      })),
            ],
          ),
        ),
      ]));
    }
    return _filas;
  }

  Widget _floatingActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
            heroTag: 'add',
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'user',
                  arguments: {'usuario': Usuario()});
            }),
      ],
    );
  }
}
