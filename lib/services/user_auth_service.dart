import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:ulcernosis/models/doctor.dart";
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

class UserServiceAuth with ChangeNotifier {
//get bearer token

  List<Doctor> postDoctors = [];
  Future<String?> getBearerToken(String email, String password) async {
    //var email = prefs.email;
    //var password = prefs.password;
    try {
      var response = await http.post(
        Uri.parse("${authURL}authenticate"),
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
        Uri.parse("${authURL}authenticateId"),
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
        int token = json.decode(response.body)["id"];
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
    return null;
  }

  Future<List<Doctor>> getDoctors({String? query}) async {
    var token = prefs.token;
    try {
      var response = await http.get(
        Uri.parse("${baseURLDoctor}search"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Doctor> doctors =
            body.map((dynamic item) => Doctor.fromJson(item)).toList();
        if (query != null) {
          doctors = doctors
              .where((element) => element.fullNameDoctor
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
        notifyListeners();
        return doctors;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return postDoctors;
    }
  }

  Future<Object?> registerDoctor(
      String fullNameDoctor,
      String password,
      String email,
      String stateCivil,
      String address,
      String phone,
      String dni,
      String age) async {
    try {
      var response = await http.post(
        Uri.parse("${authURL}register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "fullNameDoctor": fullNameDoctor,
          "password": password,
          "email": email,
          "stateCivil": stateCivil,
          "address": address,
          "phone": phone,
          "dni": dni,
          "age": age,
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
  Future<Doctor?> getDoctorById(String id) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${baseURLDoctor}search/$id"),
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
        return Doctor.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<List<Doctor>> getDoctorsByStateCivil(String stateCivil,
      {String? query}) async {
    try {
      http.Response response = await http.get(
        Uri.parse("${baseURLDoctor}state/$stateCivil"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Doctor> doctors =
            body.map((dynamic item) => Doctor.fromJson(item)).toList();
        if (query != null) {
          doctors = doctors
              .where((element) => element.fullNameDoctor
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
        return doctors;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return postDoctors;
    }
  }

  //updateDoctor(Doctor(fullNameDoctor.text, password, email, stateCivil, address, phone, dni, age)))
  Future<Doctor> updateDoctor(String id, Doctor doctors) async {
    Map data = {
      "fullNameDoctor": doctors.fullNameDoctor,
      "email": prefs.email,
      "stateCivil": doctors.stateCivil,
      "address": doctors.address,
      "phone": doctors.phone,
      "dni": doctors.dni,
      "age": doctors.age,
    };
    var response = await http.put(Uri.parse('$baseURLDoctor$id'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      notifyListeners();
      print("Actualizacion exitosa");
      return Doctor.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<Doctor> updateDoctorTest(String id,
      {String? fullNameDoctor,
      String? stateCivil,
      String? address,
      String? phone,
      String? dni,
      String? age}) async {
    Doctor doctor = Doctor();
    var id = await getAuthenticateId(prefs.email, prefs.password);
    doctor = (await getDoctorById(id.toString()))!;
    Map data = {
      "fullNameDoctor":
          fullNameDoctor!.isEmpty ? doctor.fullNameDoctor : fullNameDoctor,
      "email": prefs.email,
      "stateCivil": stateCivil!.isEmpty ? doctor.stateCivil : stateCivil,
      "address": address!.isEmpty ? doctor.address : address,
      "phone": phone!.isEmpty ? doctor.phone : phone,
      "dni": dni!.isEmpty ? doctor.dni : dni,
      "age": age!.isEmpty ? doctor.age : age,
    };
    var response = await http.put(Uri.parse('$baseURLDoctor$id'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      notifyListeners();
      print("Actualizacion exitosa");
      return Doctor.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<void> deleteDoctor(String id) async {
    var response = await http.delete(
      Uri.parse('$baseURLDoctor$id'),
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
