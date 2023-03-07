import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

class MedicAuthServic with ChangeNotifier {
//get bearer token

  List<Medic> postMedics = [];
  Future<String?> getBearerToken(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse("${authURL}auth/authenticate"),
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
        var token = json.decode(response.body)["token"];
        notifyListeners();
        return token;
      }
      if (response.statusCode == 403) {
        print("Error no deseado");
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return "";
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
  Future<List<Medic>> getMedics({String? query,String? dni}) async {
    var token = prefs.token;
    try {
      var response = await http.get(
        Uri.parse("${authURL}medics"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Medic> medics =
            body.map((dynamic item) => Medic.fromJson(item)).toList();
        if (query != null) {
          medics = medics
              .where((element) =>
                  element.fullName.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
        notifyListeners();
        return medics;
      }else if(response.statusCode==400){
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Medic> medics =
            body.map((dynamic item) => Medic.fromJson(item)).toList();
        if(dni != null){
          medics = medics
              .where((element) =>
                  element.dni.toLowerCase().contains(dni.toLowerCase()))
              .toList();
        }
        notifyListeners();
        return medics;
      } 
      
      else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return postMedics;
    }
  }

  Future<Object?> registerMedic(
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
        },
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "password": password,
          "dni": dni,
          "age": age,
          "address": address,
          "phone": phone,
          "cmp": cmp,
          "rol": rol,
          "civilStatus": stateCivil,
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
        var token = await getBearerToken(email, password);
        prefs.token = token.toString();
        print("Registro Exitoso");
        notifyListeners();
        return response;
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return "";
  }

  //get byid
  Future<Medic?> getMedicById(String id) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}medics/$id"),
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
        return Medic.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  /*Future<List<Medic>> getMedicsByStateCivil(String stateCivil,
      {String? query}) async {
    try {
      http.Response response = await http.get(
        Uri.parse("${baseURLMedic}state/$stateCivil"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Medic> medics =
            body.map((dynamic item) => Medic.fromJson(item)).toList();
        if (query != null) {
          medics = medics
              .where((element) => element.fullName
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
        return Medics;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return postMedics;
    }
  }*/

  //updateMedic(Medic(fullNameMedic.text, password, email, stateCivil, address, phone, dni, age)))
  Future<Medic> updateMedic(String id,
      {String? fullNameMedic,
      String? stateCivil,
      String? address,
      String? phone,
      String? dni,
      String? age,
      String? cmp}) async {
    Medic medic = Medic();
    var id = await getAuthenticateId(prefs.email, prefs.password);
    medic = (await getMedicById(id.toString()))!;
    Map data = {
      "fullName": fullNameMedic!.isEmpty ? medic.fullName : fullNameMedic,
      "email": prefs.email,
      "cmp": cmp!.isEmpty ? medic.cmp : cmp,
      "address": address!.isEmpty ? medic.address : address,
      "phone": phone!.isEmpty ? medic.phone : phone,
      "dni": dni!.isEmpty ? medic.dni : dni,
      "age": age!.isEmpty ? medic.age : age,
      "civilStatus": stateCivil!.isEmpty ? medic.civilStatus : stateCivil,
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
      return Medic.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<void> deleteMedic(String id) async {
    var response = await http.delete(
      Uri.parse('${authURL}medics/$id/delete-medic'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${prefs.token}",
      },
    );
    if (response.statusCode == 200) {
      notifyListeners();
      print("Eliminado");
    } else {
      throw Exception("Failed to load data");
    }
  }

  //Multipart Request http put
  Future<String?> uploadImage(filename, url) async {
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }
}
