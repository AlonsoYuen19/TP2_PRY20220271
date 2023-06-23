import 'dart:convert';

Appointment appointmentFromJson(String str) => Appointment.fromJson(json.decode(str));

String appointmentToJson(Appointment data) => json.encode(data.toJson());

class Appointment {
    Appointment({
        this.id=0,
        this.dateAsigDiag="",
        this.status="",
        this.address="",
    });

    int id;
    String dateAsigDiag;
    String status;
    String address;

    factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        dateAsigDiag: json["dateAsigDiag"],
        status: json["status"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dateAsigDiag": dateAsigDiag,
        "status": status,
        "address": address,
    };
}