import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/nurse.dart';
import "package:http/http.dart" as http;
import '../utils/helpers/constant_variables.dart';

class NurseAuthService with ChangeNotifier {
  Future<List<Nurse>> getNurses({String? query}) async {
    var token = prefs.token;
    try {
      var response = await http.get(
        Uri.parse("${baseURLNurse}search"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Nurse> nurses =
            body.map((dynamic item) => Nurse.fromJson(item)).toList();
        if (query != null) {
          nurses = nurses
              .where((element) => element.fullNameNurse
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
        notifyListeners();
        print(body);
        return nurses;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      throw Exception('No se pudo conectar al servidor: ${e.message}');
    } catch (e) {
      throw Exception('Se produjo un error al cargar los objetos: $e');
    }
  }

  Future<Nurse?> getNurseById() async {
    try {
      var id = prefs.idPatient;
      http.Response result = await http.get(
        Uri.parse("$baseURLNurse$id"),
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
        return Nurse.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<Nurse> updateNurse(
      {String? fullNameNurse,
      String? email,
      String? stateCivil,
      String? address,
      String? phone,
      String? dni,
      String? age}) async {
    Nurse nurse = Nurse();
    var id = prefs.idPatient;
    nurse = (await getNurseById())!;
    Map data = {
      "fullNameNurse":
          fullNameNurse!.isEmpty ? nurse.fullNameNurse : fullNameNurse,
      "email": email!.isEmpty ? nurse.email : email,
      "stateCivil": stateCivil!.isEmpty ? nurse.stateCivil : stateCivil,
      "address": address!.isEmpty ? nurse.address : address,
      "phone": phone!.isEmpty ? nurse.phone : phone,
      "dni": dni!.isEmpty ? nurse.dni : dni,
      "age": age!.isEmpty ? nurse.age : age,
    };
    var response = await http.put(Uri.parse('$baseURLNurse$id'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      notifyListeners();
      print("Actualizacion exitosa");
      return Nurse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<Object?> registerPatient(
      String fullNameNurse,
      String email,
      String stateCivil,
      String address,
      String phone,
      String dni,
      String age) async {
    try {
      var response = await http.post(
        Uri.parse("${baseURLNurse}save"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode({
          "fullNameNurse": fullNameNurse,
          "email": email,
          "password": "#God156868",
          "stateCivil": stateCivil,
          "address": address,
          "phone": phone,
          "dni": dni,
          "age": age,
        }),
      );
      if (response.statusCode == 200) {
        print("Registro de paciente exitoso");
        print(response.body);

        notifyListeners();
        return response;
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return "";
  }
}
