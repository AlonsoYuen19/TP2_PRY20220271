import 'dart:convert';
import 'dart:io';

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

  Future<int?> getAuthenticateUserId(String email, String password) async {
    var email = prefs.email;
    var password = prefs.password;
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
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<Users?> getUsersById(String id) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}users/$id"),
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
}
