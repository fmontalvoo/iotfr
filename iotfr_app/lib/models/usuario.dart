import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  bool activo;
  bool admin;
  String apellidos;
  String email;
  int id;
  String nombres;
  String password;
  String sitio;
  String telefono;
  String fcmToken;
  String username;

  Usuario({
    this.activo = true,
    this.admin = false,
    this.apellidos,
    this.email,
    this.id,
    this.nombres,
    this.password,
    this.sitio,
    this.telefono,
    this.fcmToken,
    this.username,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        activo: json["activo"],
        admin: json["admin"],
        apellidos: json["apellidos"],
        email: json["email"],
        id: json["id"],
        nombres: json["nombres"],
        password: json["password"],
        sitio: json["sitio"],
        telefono: json["telefono"],
        fcmToken: json["fcm_token"],
        username: json["username"],
      );

  Map<String, dynamic> toJsonData() => {
        "activo": activo,
        "admin": admin,
        "apellidos": apellidos,
        "email": email,
        "id": id,
        "nombres": nombres,
        "password": password,
        "sitio": sitio,
        "telefono": telefono,
        "fcm_token": fcmToken,
        "username": username,
      };

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "apellidos": apellidos,
        "nombres": nombres,
        "telefono": telefono,
        "sitio": sitio,
        "password": password,
        "confirm_password": password
      };
}
