import 'dart:convert';

Patient patientFromJson(String str) => Patient.fromJson(json.decode(str));

String patientToJson(Patient data) => json.encode(data.toJson());

class Patient {
    Patient({
        this.id=0,
        this.fullName="",
        this.email="",
        this.dni="",
        this.phone="",
        this.age=0,
        this.address="",
        this.civilStatus="",
        this.medicId=0,
        this.createdAt="",
    });

    int id;
    String fullName;
    String email;
    String dni;
    String phone;
    int age;
    String address;
    String civilStatus;
    int medicId;
    String createdAt;

    factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        fullName: json["fullName"],
        email: json["email"],
        dni: json["dni"],
        phone: json["phone"],
        age: json["age"],
        address: json["address"],
        civilStatus: json["civilStatus"],
        medicId: json["medicId"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "dni": dni,
        "phone": phone,
        "age": age,
        "address": address,
        "civilStatus": civilStatus,
        "medicId": medicId,
        "createdAt": createdAt,
    };
}