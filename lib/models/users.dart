import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
    Users({
        this.fullName="",
        this.email="",
        this.password="",
        this.dni="",
        this.phone="",
        this.age="",
        this.address="",
        this.cmp,
        this.cep,
        this.role="",
        this.civilStatus="",
    });

    String fullName;
    String email;
    String password;
    String dni;
    String phone;
    String age;
    String address;
    dynamic cmp;
    dynamic cep;
    String role;
    String civilStatus;

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        fullName: json["fullName"],
        email: json["email"],
        password: json["password"],
        dni: json["dni"],
        phone: json["phone"],
        age: json["age"],
        address: json["address"],
        cmp: json["cmp"],
        cep: json["cep"],
        role: json["role"],
        civilStatus: json["civilStatus"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "password": password,
        "dni": dni,
        "phone": phone,
        "age": age,
        "address": address,
        "cmp": cmp,
        "cep": cep,
        "role": role,
        "civilStatus": civilStatus,
    };
}
