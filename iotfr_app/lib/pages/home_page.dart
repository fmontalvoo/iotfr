import 'package:flutter/material.dart';
import 'package:iotfr_app/models/usuario.dart';
import 'package:iotfr_app/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final Usuario usuario;

  const HomePage({
    Key key,
    this.usuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IOTFR Aplicación Movil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_showLogo(), _content(), _contacts()],
        ),
      ),
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF3B343D),
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: Colors.white),
          ),
          child: buildDrawer(context)),
    );
  }

  Widget _showLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: SizedBox(
            width: 300,
            height: 300,
            child: Image.asset(
              "assets/qualtronic.png",
              fit: BoxFit.contain,
            )),
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "QUAL-TRONIC Domótica & Seguridad. Hace posible que la Seguridad, Control y "
        " Confort de tu casa o negocio esté al alcance de tus manos. Puedes controlar todos los"
        "dispositivos instalados en todo momento y desde cualquier parte del mundo mediante una "
        "aplicación móvil o con un solo click de tu computador. \n\nContactos: \n\nTelfs:",
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _contacts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton(
              onPressed: () => _launchURL('tel:+593987949069'),
              child: Text('+593 987 949 069',
                  style: TextStyle(
                    color: Colors.blue,
                  ))),
          FlatButton(
              onPressed: () => _launchURL('tel:+593996344570'),
              child: Text('+593 996 344 570',
                  style: TextStyle(
                    color: Colors.blue,
                  ))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Correo:'),
              SizedBox(width: 5.0),
              FlatButton(
                onPressed: () {
                  final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'qualtronic.ec@gmail.com',
                      queryParameters: {'subject': 'Escriba su asunto aqui'});
                  _launchURL(_emailLaunchUri.toString());
                },
                child: Text('qualtronic.ec@gmail.com',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Web:'),
              SizedBox(width: 5.0),
              FlatButton(
                onPressed: () => _launchURL("https://www.qualtronic.ec"),
                child: Text('www.qualtronic.ec',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    final UserProvider _userProvider = UserProvider();
    return Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: 100,
              child: Image(
                  image: AssetImage("assets/logo.png"), fit: BoxFit.contain),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${usuario.nombres} ${usuario.apellidos}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                        child: Text(usuario.email),
                        onDoubleTap: () {
                          _showMaterialDialog(context, usuario.fcmToken);
                        }),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.tag_faces,
              color: Colors.white,
            ),
            title: Text('Registro rostro'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'face');
            },
          ),
          usuario.admin
              ? ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  title: Text('Gestión de usuarios'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'users');
                  },
                )
              : Container(),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Colors.white,
            ),
            title: Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'history');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text('Salir'),
            onTap: () {
              _userProvider.logout();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }

  _showMaterialDialog(BuildContext context, String token) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("FCM Token"),
              content: new TextField(
                controller: TextEditingController(text: token),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
