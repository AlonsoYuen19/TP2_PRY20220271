import 'dart:convert';

Nurse nurseFromJson(String str) => Nurse.fromJson(json.decode(str));
Nurse nurseFromJson2(String str) => Nurse.fromJson2(json.decode(str));
String nurseToJson(Nurse data) => json.encode(data.toJson());

class Nurse {
  Nurse({
    this.id = 0,
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
    this.itWasNotified = false,
    this.createdAt = "",
  });

  int id;
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
  bool itWasNotified;
  String createdAt;
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
  factory Nurse.fromJson2(Map<String, dynamic> json) => Nurse(
        id: json["id"],
        fullName: json["fullName"],
        email: json["email"],
        dni: json["dni"],
        phone: json["phone"],
        age: json["age"],
        address: json["address"],
        cep: json["cep"],
        isAuxiliar: json["isAuxiliar"],
        civilStatus: json["civilStatus"],
        rol: json["role"],
        haveTeamWork: json["haveTeamWork"],
        itWasNotified: json["itWasNotified"],
        createdAt: json["createdAt"],
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
        "role": rol,
        "civilStatus": civilStatus,
        "isAuxiliar": isAuxiliar,
        "haveTeamWork": haveTeamWork,
        "createdAt": createdAt,
      };
}
