import 'package:flutter/material.dart';
import 'package:iotfr_app/models/usuario.dart';

import 'package:iotfr_app/providers/user_provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();

  final UserProvider _userProvider = UserProvider();

  String _password;
  String _confirmPassword;

  Usuario _usuario = Usuario();

  TextEditingController _txtUsernameController = TextEditingController();
  TextEditingController _txtEmailController = TextEditingController();
  TextEditingController _txtNombresController = TextEditingController();
  TextEditingController _txtApellidosController = TextEditingController();
  TextEditingController _txtTelefonoController = TextEditingController();
  TextEditingController _txtSitioController = TextEditingController();
  TextEditingController _txtPasswordController = TextEditingController();
  TextEditingController _txtConfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    if (arguments['usuario'] != null) {
      _usuario = arguments['usuario'];
      _txtUsernameController.text = _usuario.username;
      _txtEmailController.text = _usuario.email;
      _txtNombresController.text = _usuario.nombres;
      _txtApellidosController.text = _usuario.apellidos;
      _txtTelefonoController.text = _usuario.telefono;
      _txtSitioController.text = _usuario.sitio;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Crear/Editar Usuario')),
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
              _txtUsername(),
              SizedBox(height: 15.0),
              _txtEmail(),
              SizedBox(height: 15.0),
              _txtNombres(),
              SizedBox(height: 15.0),
              _txtApellidos(),
              SizedBox(height: 15.0),
              _txtTelefono(),
              SizedBox(height: 25.0),
              _txtSitio(),
              SizedBox(height: 15.0),
              _txtPassword(),
              SizedBox(height: 15.0),
              _txtConfirmPassword(),
              SizedBox(height: 15.0),
              _btnGuardar(),
              SizedBox(height: 25.0),
            ],
          ),
        ));
  }

  Widget _txtUsername() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _txtUsernameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Nombre de usuario',
        labelText: 'Nombre de usuario',
      ),
      onSaved: (value) => _usuario.username = value,
    );
  }

  Widget _txtEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _txtEmailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Correo electrónico',
        labelText: 'Correo electrónico',
      ),
      onSaved: (value) => _usuario.email = value,
    );
  }

  Widget _txtNombres() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _txtNombresController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Nombres',
        labelText: 'Nombres',
      ),
      onSaved: (value) => _usuario.nombres = value,
    );
  }

  Widget _txtApellidos() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _txtApellidosController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Apellidos',
        labelText: 'Apellidos',
      ),
      onSaved: (value) => _usuario.apellidos = value,
    );
  }

  Widget _txtTelefono() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _txtTelefonoController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Teléfono',
        labelText: 'Teléfono',
      ),
      onSaved: (value) => _usuario.telefono = value,
    );
  }

  Widget _txtSitio() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _txtSitioController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Nombre del sitio',
        labelText: 'Nombre del sitio',
      ),
      onSaved: (value) => _usuario.sitio = value,
    );
  }

  Widget _txtPassword() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _txtPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Ingrese su contraseña',
        labelText: 'Ingrese su contraseña',
      ),
      onSaved: (value) => _password = value,
    );
  }

  Widget _txtConfirmPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _txtConfirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Vuelva a ingrese su contraseña',
        labelText: 'Vuelva a ingrese su contraseña',
      ),
      onSaved: (value) => _confirmPassword = value,
    );
  }

  Widget _btnGuardar() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text('Guardar'),
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
      if (_password == _confirmPassword) {
        if (_password.isNotEmpty) _usuario.password = _password;
        Map<String, dynamic> response = {};
        if (_usuario.id != null)
          response = await _userProvider.editarUsuario(_usuario);
        else
          response = await _userProvider.crearUsuario(_usuario);
        print(response['status']);
      }
      Navigator.pop(context);
    }
  }
}
