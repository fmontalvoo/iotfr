import 'package:flutter/material.dart';
import 'package:iotfr_app/models/usuario.dart';
import 'package:iotfr_app/pages/home_page.dart';
import 'package:iotfr_app/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username;

  String _password;

  final _formKey = GlobalKey<FormState>();

  final UserProvider _userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario>(
        future: _userProvider.getUserData(),
        builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.data.activo == null) return login();
          return HomePage(usuario: snapshot.data);
        });
  }

  Widget login() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fondo(),
          Center(
            child: _form(context),
          )
        ],
      ),
    );
  }

  Widget _fondo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black87,
    );
  }

  Widget _logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          width: 300,
          child:
              Image(image: AssetImage("assets/logo.png"), fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          SafeArea(child: _logo()),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white54,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Iniciar Sesión',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                      key: _formKey,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 30.0),
                              _txtUsername(),
                              SizedBox(height: 30.0),
                              _txtPassword(),
                              SizedBox(height: 30.0),
                              _btnIniciar(context),
                              SizedBox(height: 10.0)
                            ],
                          )))
                ],
              ),
            ),
          ),
          SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _txtUsername() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: 'Ingrese su nombre de usuario',
          labelText: 'Usuario',
          prefixIcon: Icon(Icons.alternate_email)),
      onSaved: (value) => _username = value,
    );
  }

  Widget _txtPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: 'Ingrese su Contraseña',
          labelText: 'Contraseña',
          prefixIcon: Icon(Icons.lock)),
      onSaved: (value) => _password = value,
    );
  }

  Widget _btnIniciar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RaisedButton(
        color: Color(0xFF3B343D),
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.2, vertical: 20.0),
          child: Text('Ingresar'),
        ),
        onPressed: () {
          submit();
          //  Navigator.pushReplacementNamed(context, 'home')
        });
  }

  void submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final response =
          await _userProvider.login(_username.trim(), _password.trim());
      if (response['status'] == 200) {
        final data = response['usuario'] as Map<String, dynamic>;
        setState(() {
        _userProvider.setData(data);
        });
      }
    }
  }
}
