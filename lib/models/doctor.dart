import 'dart:convert';

Doctor doctorFromJson(String str) => Doctor.fromJson(json.decode(str));

String doctorToJson(Doctor data) => json.encode(data.toJson());
//final prefs = SaveData();

class Doctor {
  Doctor({
    this.fullNameDoctor = "",
    this.password = "",
    this.email = "",
    this.stateCivil = "",
    this.address = "",
    this.phone = "",
    this.dni = "",
    this.age = "",
    this.state = true,
    this.rol = "USER",
  });

  String fullNameDoctor;
  String password;
  String email;
  String stateCivil;
  String address;
  String phone;
  String dni;
  String age;
  String rol;
  bool state;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        fullNameDoctor: json["fullNameDoctor"],
        password: json["password"],
        email: json["email"],
        stateCivil: json["stateCivil"],
        address: json["address"],
        phone: json["phone"],
        dni: json["dni"],
        age: json["age"],
        state: json["state"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "fullNameDoctor": fullNameDoctor,
        "password": password,
        "email": email,
        "stateCivil": stateCivil,
        "address": address,
        "phone": phone,
        "dni": dni,
        "age": age,
        "state": true,
        "rol": "USER",
      };
}
