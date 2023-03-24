// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import '../models/nurse.dart';
import '../utils/helpers/constant_variables.dart';

class TeamWorkService with ChangeNotifier {
  Future<List<Nurse>> getNursesByTeamWork() async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}nurses/medic/${prefs.idMedic}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Nurse> nurses =
            body.map((dynamic item) => Nurse.fromJson2(item)).toList();
        notifyListeners();
        return nurses;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      List<Nurse> postUsers = [];
      return postUsers;
    }
  }

  Future<List<Nurse>> getAvailableNurses() async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}nurses/get-nurses-team-work/false"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Nurse> nurses =
            body.map((dynamic item) => Nurse.fromJson2(item)).toList();
        notifyListeners();
        return nurses;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      List<Nurse> postUsers = [];
      return postUsers;
    }
  }

  Future<Object?> createTeamWork(BuildContext context, int id) async {
    Map data = {"medicId": prefs.idMedic, "nurseId": id};
    var response =
        await http.post(Uri.parse("${authURL}team-works/create-team-work"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${prefs.token}",
            },
            body: json.encode(data));
    if (response.statusCode == 201) {
      print("Equipo creado");
      return json.decode(response.body);
    } else {
      print("Error al crear el equipo");
      return null;
    }
  }

  Future<void> deleteNurseOfTheTeamWork(int id) async {
    var response = await http.delete(
      Uri.parse('${authURL}team-works/delete-by-nurse/$id'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${prefs.token}",
      },
    );
    if (response.statusCode == 200) {
      notifyListeners();
      print("Eliminado el enfermero del equipo");
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<Nurse?> getNurseByIdTW(BuildContext context, int id) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}nurses/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      //prefs.showDialog = true;
      if (result.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(result.bodyBytes));
        notifyListeners();
        return Nurse.fromJson2(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<Uint8List> getNurseImageTeamWork(int id) async {
    final response = await http.get(
      Uri.parse('${authURL}nurses/$id/profile-photo'),
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
}
