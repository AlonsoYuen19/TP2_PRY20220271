
import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/patient.dart';

import '../utils/helpers/constant_variables.dart';

class DiagnosisService{
    Future<List<Patient>> getPatientsNoAssigned() async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}patients/medic/${prefs.idMedic}/get-patients-by-assigned/false"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Patient> patients =
            body.map((dynamic item) => Patient.fromJson(item)).toList();
        print(body);
        return patients;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return [];
    }
  }
}