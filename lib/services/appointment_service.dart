// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/appointment.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';

import '../models/patient.dart';
import '../pages/management/team_work_nurse_profile.dart';
import '../utils/helpers/constant_variables.dart';

class AppointmentService {
  Future<Object?> createAppointment(BuildContext context, String date,
      String address, int idNurse, int idPatient) async {
    Map data = {
      "dateAsigDiag": date,
      "address": address,
      "medicId": prefs.idMedic,
      "nurseId": idNurse,
      "patientId": idPatient
    };
    var response =
        await http.post(Uri.parse("${authURL}appointments/save-appointment"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${prefs.token}",
            },
            body: json.encode(data));
    if (response.statusCode == 201) {
      print("Itinerario creado");
      mostrarAlertaExito(context, "La Cita ha sido creada exitosamente", () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamWorkNurseProfile(
                      id: idNurse,
                    )));
      });
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      String errorCode = json.decode(response.body)["errorCode"];
      if (errorCode == "TEAM_WORK_NOT_EXISTS") {
        mostrarAlertaError(context, "Ya existe un itinerario para este día",
            () {
          Navigator.pop(context);
        });
      } else {
        mostrarAlertaError(
            context, "No se está enviando nungún horario de entrada o salida",
            () {
          Navigator.pop(context);
        }, faltaDatos: true);
      }
    } else {
      print("Error al crear el itinerario");
      return null;
    }
    return null;
  }

  Future<Patient?> getPatientOnAppointmentById(int idPatient) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}patients/$idPatient"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      if (result.statusCode == 200) {
        print(result.body);
        final jsonResponse = json.decode(utf8.decode(result.bodyBytes));
        return Patient.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }
    Future<List<Appointment>> getAppointmentsByNurseId(int idNurse) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}appointments/nurse/$idNurse"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Appointment> appointments =
            body.map((dynamic item) => Appointment.fromJson(item)).toList();
        print(body);
        return appointments;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      throw Exception('No se pudo conectar al servidor: ${e.message}');
    } catch (e) {
      throw Exception('Se produjo un error al cargar los objetos: $e');
    }
  }
    Future<void> deleteAppointByNurseId(int id) async {
    var response = await http.delete(
      Uri.parse('${authURL}appointments/delete-appointment/$id'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${prefs.token}",
      },
    );
    if (response.statusCode == 200) {
      print("Cita Elimanda con exito");
    } else {
      throw Exception("Failed to load data");
    }
  }
}
