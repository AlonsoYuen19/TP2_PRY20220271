// ignore_for_file: use_build_context_synchronously
import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import "../pages/profile/profile.dart";
import "../pages/sign_in/login.dart";
import "../utils/widgets/alert_dialog.dart";

class MedicAuthServic with ChangeNotifier {
//get bearer token

  List<Medic> postMedics = [];
  List<Medic> getDnis = [];
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
    /*var email = prefs.email;
    var password = prefs.password;*/
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

  Future<List<Medic>> getMedics({String? query}) async {
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
        print(body);
        return medics;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return postMedics;
    }
  }

  Future<Object?> registerMedic(
    BuildContext context,
    String fullName,
    String email,
    String password,
    String dni,
    String age,
    String address,
    String phone,
    String cmp,
    String rol,
    String stateCivil,
  ) async {
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
          "role": rol,
          "civilStatus": stateCivil,
        }),
      );
      if (response.statusCode == 201) {
        print(response.body);
        print("Registro Exitoso");
                              mostrarAlertaExito(context, "Registro Exitoso", () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      });
        notifyListeners();
        return response;
      } else if (response.statusCode == 400) {
        String errorCode = json.decode(response.body)["errorCode"];
        print(errorCode);
        notifyListeners();
        //return token;
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
        if (errorCode == "CMP_EXISTS") {
          print("CMP ya registrado");
          return mostrarAlertaError(
              context, "El CMP del médico ya se encuentra registrado",
              () async {
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
  Future<Object?> updateMedic(
    BuildContext context, {
    String? fullNameMedic,
    String? stateCivil,
    String? address,
    String? phone,
    String? dni,
    int? age,
  }) async {
    Medic medic = Medic();
    Map data = {
      "fullName": fullNameMedic!.isEmpty ? medic.fullName : fullNameMedic,
      "dni": dni!.isEmpty ? medic.dni : dni,
      "phone": phone!.isEmpty ? medic.phone : phone,
      "age": age!.isNaN ? medic.age : age,
      "address": address!.isEmpty ? medic.address : address,
      "civilStatus": stateCivil!.isEmpty ? medic.civilStatus : stateCivil,
    };
    var response = await http.put(
        Uri.parse('${authURL}medics/${prefs.idMedic}/update-medic'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      notifyListeners();
      print("Actualizacion exitosa");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
        (route) => false,
      );
      return Medic.fromJson(json.decode(utf8.decode(response.bodyBytes)));
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


  Future<Uint8List> getImageFromBackend() async {
    final response = await http.get(
      Uri.parse('${authURL}medics/${2}/profile-photo'),
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
