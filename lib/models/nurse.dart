import 'dart:convert';

Nurse nurseFromJson(String str) => Nurse.fromJson(json.decode(str));

String nurseToJson(Nurse data) => json.encode(data.toJson());

class Nurse {
  Nurse({
    this.id = 0,
    this.fullNameNurse = "",
    this.password = "aS1#s462",
    this.email = "",
    this.stateCivil = "",
    this.address = "",
    this.phone = "",
    this.dni = "",
    this.age = "",
  });

  int id;
  String fullNameNurse;
  String password;
  String email;
  String stateCivil;
  String address;
  String phone;
  String dni;
  String age;

  factory Nurse.fromJson(Map<String, dynamic> json) => Nurse(
        id: json["id"],
        fullNameNurse: json["fullNameNurse"],
        password: json["password"],
        email: json["email"],
        stateCivil: json["stateCivil"],
        address: json["address"],
        phone: json["phone"],
        dni: json["dni"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullNameNurse": fullNameNurse,
        "password": password,
        "email": email,
        "stateCivil": stateCivil,
        "address": address,
        "phone": phone,
        "dni": dni,
        "age": age,
      };
}
