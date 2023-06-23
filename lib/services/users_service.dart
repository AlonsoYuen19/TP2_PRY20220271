import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/users.dart';
import "package:http/http.dart" as http;
import '../utils/helpers/constant_variables.dart';

class UsersAuthService with ChangeNotifier {
  List<Users> postUsers = [];
  Future<List<Users>> getUsers() async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}users"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Users> users =
            body.map((dynamic item) => Users.fromJson(item)).toList();
        notifyListeners();
        return users;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      return postUsers;
    }
  }


  Future<bool> logOutToken() async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}auth/logout"),
        headers: {
          'Authorization': 'Bearer ${prefs.token}',
        },
      );
      if (response.statusCode == 200) {
        print("Se deslogeo correctamente");
        return true;
      } else {
        print("Hubo un error al deslogearse");
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print('Error de conexión: ${e.message}');
      return false;
    }
  }

  Future<int?> getAuthenticateUserId(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse("${authURL}auth/get-user-id/authenticateId"),
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
      if (response.statusCode == 500) {
        String message = json.decode(response.body)["message"];
        if (message == "Bad credentials") {
          return 0;
        }
      }
    } on SocketException catch (e) {
      if (e.osError?.errorCode == 61) {
        // El servidor no está en ejecución
        print('Error: El servidor no está en ejecución.');
      } else {
        // Otro error de conexión
        print('Error: $e');
      }
    }
    return -1;
  }

  Future<Users?> getUsersById() async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}users/${prefs.idUsers}"),
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
        return Users.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<String?> getAuthenticateIdRole(String email, String password) async {
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

  Future<Uint8List> getMedicImageFromBackend() async {
    final response = await http.get(
      Uri.parse('${authURL}medics/${prefs.idMedic}/profile-photo'),
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

  Future<Uint8List> getNurseImageFromBackend() async {
    final response = await http.get(
      Uri.parse('${authURL}nurses/${prefs.idNurse}/profile-photo'),
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

  Future<bool> updatePhotoMedic(Uint8List imageBytes) async {
    final url = '${authURL}medics/${prefs.idMedic}/profile-photo';
    final request = http.MultipartRequest('PUT', Uri.parse(url));
    final multipartFile = http.MultipartFile.fromBytes('file', imageBytes,
        filename: prefs.image, contentType: MediaType('image', 'jpeg'));
    request.headers['Authorization'] = 'Bearer ${prefs.token}';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
      return true;
    } else {
      print('Error uploading image. Status code: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> updatePhotoNurse(Uint8List imageBytes) async {
    final url = '${authURL}nurses/${prefs.idNurse}/profile-photo';
    final request = http.MultipartRequest('PUT', Uri.parse(url));
    final multipartFile = http.MultipartFile.fromBytes('file', imageBytes,
        filename: prefs.image, contentType: MediaType('image', 'jpeg'));
    request.headers['Authorization'] = 'Bearer ${prefs.token}';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
      return true;
    } else {
      print('Error uploading image. Status code: ${response.statusCode}');
      return false;
    }
  }
}
