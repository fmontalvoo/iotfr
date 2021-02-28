import 'dart:convert';

Historial historialFromJson(String str) => Historial.fromJson(json.decode(str));

String historialToJson(Historial data) => json.encode(data.toJson());

class Historial {
  int id;
  String fecha;
  String nombreApellido;

  Historial({
    this.id,
    this.fecha,
    this.nombreApellido,
  });

  factory Historial.fromJson(Map<String, dynamic> json) => Historial(
        id: json["id"],
        fecha: json["fecha"],
        nombreApellido: json["nombre_apellido"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "nombre_apellido": nombreApellido,
      };
}
