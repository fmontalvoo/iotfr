import 'package:flutter/material.dart';
import 'package:iotfr_app/providers/opencv_provider.dart';

class FaceRegisterPage extends StatefulWidget {
  @override
  _FaceRegisterPageState createState() => _FaceRegisterPageState();
}

class _FaceRegisterPageState extends State<FaceRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final OpenCVProvider _cvProvider = OpenCVProvider();

  String _nombre;
  String _apellido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escanear rostro')),
      body: _body(),
    );
  }

  Widget _body() {
    return Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 25.0),
              _intrucciones(),
              SizedBox(height: 25.0),
              _txtNombre(),
              SizedBox(height: 15.0),
              _txtApellido(),
              SizedBox(height: 15.0),
              _btnEscanear(),
              SizedBox(height: 25.0),
            ],
          ),
        ));
  }

  Widget _txtNombre() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Nombre',
        labelText: 'Nombre',
      ),
      onSaved: (value) => _nombre = value,
    );
  }

  Widget _intrucciones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("1) Ingrese su nombre y apellido",
            textAlign: TextAlign.justify, style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 10.0),
        Text(
            "2) Sitúese frente a la cámara IP, mírela de frente para empezar a tomar fotografías",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18.0)),
        SizedBox(height: 10.0),
        Text(
            "3)Finalmente presione el botón \"Comenzar a escanear\" hasta que se complete el registro",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18.0)),
      ],
    );
  }

  Widget _txtApellido() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Apellido',
        labelText: 'Apellido',
      ),
      onSaved: (value) => _apellido = value,
    );
  }

  Widget _btnEscanear() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text('Comenzar a escanear'),
      ),
      color: Color(0xff3b3b3d),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0.0,
      onPressed: save,
    );
  }

  Future<void> save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Map<String, dynamic> response = {};

      response = await _cvProvider.registerFaces(_nombre, _apellido);

      if (response['status'].toString() == "200")
        showMsg(context, "Registro", "Resgistro de rostro satisfactorio !!!");
    }
    Navigator.pop(context);
  }

  static showMsg(
      BuildContext context, final String title, final String description) {
    // flutter defined function
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(description),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Cerrar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
