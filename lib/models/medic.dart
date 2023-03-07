import 'dart:convert';

Medic medicFromJson(String str) => Medic.fromJson(json.decode(str));

String medicToJson(Medic data) => json.encode(data.toJson());

class Medic {
  Medic({
    this.fullName = "",
    this.email = "",
    this.password = "",
    this.dni = "",
    this.age = 0,
    this.address = "",
    this.phone = "",
    this.cmp = "",
    this.rol = "ROLE_MEDIC",
    this.civilStatus = "",
  });

  String fullName;
  String email;
  String password;
  String dni;
  int age;
  String address;
  String phone;
  String cmp;
  String rol;
  String civilStatus;

  factory Medic.fromJson(Map<String, dynamic> json) => Medic(
        fullName: json["fullName"],
        email: json["email"],
        //password: json["password"],
        dni: json["dni"],
        age: json["age"],
        address: json["address"],
        phone: json["phone"],
        cmp: json["cmp"],
        //rol: json["rol"],
        civilStatus: json["civilStatus"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "password": password,
        "dni": dni,
        "age": age,
        "address": address,
        "phone": phone,
        "cmp": cmp,
        "rol": rol,
        "civilStatus": civilStatus,
      };
}
