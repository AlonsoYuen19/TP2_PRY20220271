import 'dart:convert';

Nurse nurseFromJson(String str) => Nurse.fromJson(json.decode(str));

String nurseToJson(Nurse data) => json.encode(data.toJson());

class Nurse {
  Nurse({
    this.fullName = "",
    this.email = "",
    this.password = "",
    this.dni = "",
    this.age = 0,
    this.address = "",
    this.cep = "",
    this.phone = "",
    this.rol = "ROLE_NURSE",
    this.civilStatus = "",
    this.isAuxiliar = false,
    this.haveTeamWork = false,
  });

  String fullName;
  String email;
  String password;
  String dni;
  int age;
  String address;
  String cep;
  String phone;
  String rol;
  String civilStatus;
  bool isAuxiliar;
  bool haveTeamWork;

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
        fullName: json["fullName"],
        email: json["email"],
        //password: json["password"],
        dni: json["dni"],
        age: json["age"],
        address: json["address"],
        cep: json["cep"],
        phone: json["phone"],
        //rol: json["rol"],
        //civilStatus: json["civilStatus"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "password": password,
        "dni": dni,
        "age": age,
        "address": address,
        "cep": cep,
        "phone": phone,
        "rol": rol,
        "civilStatus": civilStatus,
        "isAuxiliar": isAuxiliar,
        "haveTeamWork": haveTeamWork,
      };
}
