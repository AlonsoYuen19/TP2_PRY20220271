// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../utils/helpers/constant_variables.dart';
import '../utils/widgets/alert_dialog.dart';

class PatientService with ChangeNotifier {
  Future<Object?> registerPatient(
    BuildContext context,
    String fullName,
    String email,
    String dni,
    String phone,
    int age,
    String address,
    String civilStatus,
  ) async {
    try {
      var response = await http.post(
        Uri.parse("${authURL}patients/medic/${prefs.idMedic}/create-patient"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "dni": dni,
          "phone": phone,
          "age": age,
          "address": address,
          "civilStatus": civilStatus,
        }),
      );
      //TODO: Implementar el error 500 del servidor
      if (response.statusCode == 200) {
        print(response.body);
        print("Registro Exitoso");
        notifyListeners();
        /*Navigator.pushNamedAndRemoveUntil(
          context,
          'profile',
          (route) => false,
        );*/
        mostrarAlertaExito(context, "Registro Exitoso", () async {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'profile',
            (route) => false,
          );
        });
        return response;
      } else if (response.statusCode == 400) {
        String errorCode = json.decode(response.body)["errorCode"];
        print(errorCode);
        notifyListeners();
        if (errorCode == "DNI_EXISTS") {
          print("Dni ya registrado");
          return mostrarAlertaError(
              context, "El Dni ya se encuentra registrado", () async {
            Navigator.pop(context);
          });
        }

        if (errorCode == "EMAIL_EXISTS") {
          print("Email ya registrado");
          return mostrarAlertaError(
              context, "El Correo Electrónico ya se encuentra registrado",
              () async {
            Navigator.pop(context);
          });
        }
        if (errorCode == "PHONE_EXISTS") {
          print("Teléfono ya registrado");
          return mostrarAlertaError(
              context, "El teléfono ya se encuentra registrado", () async {
            Navigator.pop(context);
          });
        }
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return "";
  }

  List<Patient> postMedics = [];
  Future<List<Patient>> getPatientsByMedics({String? query}) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}patients/get_by_medic/${prefs.idMedic}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Patient> medics =
            body.map((dynamic item) => Patient.fromJson(item)).toList();
        if (query != null) {
          medics = medics
              .where((element) =>
                  element.fullName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
        notifyListeners();
        return medics;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      return postMedics;
    }
  }
  Future<List<Patient>> getPatientsNotassigned() async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}patients/medic/${prefs.idMedic}/get-patients-assigned/false"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Patient> medics =
            body.map((dynamic item) => Patient.fromJson(item)).toList();
        notifyListeners();
        return medics;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      return postMedics;
    }
  }
  List<Patient> postNurses = [];
  Future<List<Patient>> getPatientsByNurse({String? query}) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}patients/get_by_nurse/${prefs.idNurse}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Patient> nurses =
            body.map((dynamic item) => Patient.fromJson(item)).toList();
        if (query != null) {
          nurses = nurses
              .where((element) =>
                  element.fullName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
        notifyListeners();
        return nurses;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      return postNurses;
    }
  }
  Future<List<Patient>> getPatientsByNurseManageArea(int id) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}patients/get_by_nurse/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Patient> nurses =
            body.map((dynamic item) => Patient.fromJson(item)).toList();
        notifyListeners();
        return nurses;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      return postNurses;
    }
  }
  Future<Patient?> getPatientById() async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}patients/${prefs.idPatient}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      if (result.statusCode == 200) {
        print(result.body);
        final jsonResponse = json.decode(utf8.decode(result.bodyBytes));
        notifyListeners();
        return Patient.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<Object?> updatePatient(BuildContext context,
      {String? fullName,
      String? email,
      String? dni,
      String? phone,
      String? stateCivil,
      String? address,
      int? age,
      Function? onSuccess}) async {
    Patient patient = Patient();
    Map data = {
      "fullName": fullName!.isEmpty ? patient.fullName : fullName,
      "email": email!.isEmpty ? patient.email : email,
      "dni": dni!.isEmpty ? patient.dni : dni,
      "phone": phone!.isEmpty ? patient.phone : phone,
      "age": age!.isNaN ? patient.age : age,
      "address": address!.isEmpty ? patient.address : address,
      "civilStatus": stateCivil!.isEmpty ? patient.civilStatus : stateCivil,
    };
    var response = await http.put(
        Uri.parse('${authURL}patients/${prefs.idPatient}/update-patient'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      notifyListeners();
      print("Actualizacion exitosa");
      Navigator.pop(context);
      if (onSuccess != null) {
        onSuccess();
      }
      return Patient.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 400) {
      String errorCode = json.decode(response.body)["errorCode"];
      print(errorCode);
      notifyListeners();
      //return token;
      if (errorCode == "DNI_EXISTS") {
        print("Dni ya registrado");
        return mostrarAlertaError(context, "El Dni ya se encuentra registrado",
            () async {
          Navigator.pop(context);
        });
      }

      if (errorCode == "EMAIL_EXISTS") {
        print("Email ya registrado");
        return mostrarAlertaError(
            context, "El Correo Electrónico ya se encuentra registrado",
            () async {
          Navigator.pop(context);
        });
      }
      if (errorCode == "PHONE_EXISTS") {
        print("Teléfono ya registrado");
        return mostrarAlertaError(
            context, "El teléfono ya se encuentra registrado", () async {
          Navigator.pop(context);
        });
      }
      if (errorCode == "CMP_EXISTS") {
        print("CMP ya registrado");
        return mostrarAlertaError(
            context, "El CMP del médico ya se encuentra registrado", () async {
          Navigator.pop(context);
        });
      }
    } else {
      throw Exception("Failed to load data");
    }
    return null;
  }
    Future<Uint8List> getAvatarPatient(int id) async {
    final response = await http.get(
      Uri.parse('${authURL}patients/$id/profile-photo'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${prefs.token}",
      },
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al obtener la imagen: ${response.statusCode}');
    }
  }
    Future<Object?> createAssignment(int idPatient,int idNurse) async {
    Map data = {"patientId": idPatient, "nurseId": idNurse};
    var response =
        await http.post(Uri.parse("${authURL}assignments/create-assignment"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${prefs.token}",
            },
            body: json.encode(data));
    if (response.statusCode == 201) {
      print("Asignación creada exitosamente");
      return json.decode(response.body);
    } else {
      print("Error al crear la asignación");
      return null;
    }
  }
}
