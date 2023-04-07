// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/nurse.dart';
import "package:http/http.dart" as http;
import '../pages/profile/profile.dart';
import '../pages/sign_in/login.dart';
import '../utils/helpers/constant_variables.dart';
import '../utils/widgets/alert_dialog.dart';

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

  Future<Nurse?> getNurseById(BuildContext context) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}nurses/${prefs.idNurse}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      //prefs.showDialog = true;
      if (result.statusCode == 200) {
        print(result.body);
        final haveTeamWork = json.decode(result.body)["haveTeamWork"];
        if (haveTeamWork == true) {
          String resultado = await wasNotified();
          if (resultado == "true") {
            mostrarAlertaExito(
                context, "Usted ha sido registrado en un Equipo médico ",
                () async {
              Navigator.pop(context);
            });
          }
        }
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

  Future<Nurse?> getNurseByIdManage(int id) async {
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
        return Nurse.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<String> wasNotified() async {
    var response = await http
        .put(Uri.parse('${authURL}nurses/${prefs.idNurse}/notify'), headers: {
      "Authorization": "Bearer ${prefs.token}",
    });
    if (response.statusCode == 200) {
      String itWasNotified =
          json.decode(response.body)["itWasNotified"].toString();
      notifyListeners();
      print("El resultado es: " + itWasNotified.toString());
      return itWasNotified;
    } else if (response.statusCode == 409) {
      String itWasNotified = json.decode(response.body)["errorCode"].toString();
      notifyListeners();
      return itWasNotified;
    } else {
      print("Error al actualizar notificacion");
      return "Error";
    }
  }

  Future<Object?> updateNurse(
    BuildContext context, {
    String? fullName,
    String? stateCivil,
    String? address,
    String? phone,
    String? dni,
    int? age,
  }) async {
    Nurse nurse = Nurse();
    Map data = {
      "fullName": fullName!.isEmpty ? nurse.fullName : fullName,
      "dni": dni!.isEmpty ? nurse.dni : dni,
      "phone": phone!.isEmpty ? nurse.phone : phone,
      "age": age!.isNaN ? nurse.age : age,
      "address": address!.isEmpty ? nurse.address : address,
      "civilStatus": stateCivil!.isEmpty ? nurse.civilStatus : stateCivil,
    };
    var response = await http.put(
        Uri.parse('${authURL}nurses/${prefs.idNurse}/update-nurse'),
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
      return Nurse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
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

  Future<Object?> registerNurse(
      BuildContext context,
      String fullName,
      String email,
      String password,
      String dni,
      String age,
      String address,
      String phone,
      String cep,
      String rol,
      String stateCivil,
      bool isAuxiliar) async {
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
          "cep": cep,
          "isAuxiliar": isAuxiliar,
          "role": rol,
          "civilStatus": stateCivil,
        }),
      );
      if (response.statusCode == 201) {
        print("Registro de paciente exitoso");
        print(response.body);
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
        if (errorCode == "CEP_EXISTS") {
          print("CEP ya registrado");
          return mostrarAlertaError(
              context, "El CEP del enfermero ya se encuentra registrado",
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
}
