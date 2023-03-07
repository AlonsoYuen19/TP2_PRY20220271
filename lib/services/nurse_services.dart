import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/nurse.dart';
import "package:http/http.dart" as http;
import 'package:ulcernosis/services/medic_service.dart';
import '../utils/helpers/constant_variables.dart';

class NurseAuthService with ChangeNotifier {
  Future<List<Nurse>> getNurses({String? query}) async {
    var token = prefs.token;
    try {
      var response = await http.get(
        Uri.parse("${authURL}nurses"),
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
              .where((element) =>
                  element.fullName.toLowerCase().contains(query.toLowerCase()))
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
  Future<int?> getAuthenticateId(String email, String password) async {
    var email = prefs.email;
    var password = prefs.password;
    try {
      var response = await http.post(
        Uri.parse("${authURL}auth/get-type-id/authenticateId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        int id = json.decode(response.body)["id"];
        notifyListeners();
        return id;
      }
      if (response.statusCode == 403) {
        print("Error no deseado");
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }
  Future<String?> getAuthenticateIdRole(String email, String password) async {
    var email = prefs.email;
    var password = prefs.password;
    try {
      var response = await http.post(
        Uri.parse("${authURL}auth/authenticateId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode == 200) {
        String role = json.decode(response.body)["type"];
        notifyListeners();
        return role;
      }
      if (response.statusCode == 403) {
        print("Error no deseado");
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<Nurse?> getNurseById(String id) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}nurses/$id"),
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

  Future<Nurse> updateMedic(String id,
      {String? fullName,
      String? stateCivil,
      String? address,
      String? phone,
      String? dni,
      String? age,
      String? cep}) async {
    MedicAuthServic auth = MedicAuthServic();
    //auth = await
    Nurse nurse = Nurse();
    var id = await auth.getAuthenticateId(prefs.email, prefs.password);
    nurse = (await getNurseById(id.toString()))!;
    Map data = {
      "fullName": fullName!.isEmpty ? nurse.fullName : fullName,
      "email": prefs.email,
      "cmp": cep!.isEmpty ? nurse.cep : cep,
      "address": address!.isEmpty ? nurse.address : address,
      "phone": phone!.isEmpty ? nurse.phone : phone,
      "dni": dni!.isEmpty ? nurse.dni : dni,
      "age": age!.isEmpty ? nurse.age : age,
      "civilStatus": stateCivil!.isEmpty ? nurse.civilStatus : stateCivil,
    };
    var response =
        await http.put(Uri.parse('${authURL}medics/$id/update-medic'),
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

  Future<Object?> registerNurse(
      String fullName,
      String email,
      String password,
      String dni,
      String age,
      String address,
      String phone,
      String cmp,
      String rol,
      String stateCivil) async {
    try {
      var response = await http.post(
        Uri.parse("${authURL}auth/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
          "dni": dni,
          "age": age,
          "address": address,
          "phone": phone,
          "cep": cmp,
          "rol": rol,
          "civilStatus": stateCivil,
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
