import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:http_parser/http_parser.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/utils/widgets/alert_dialog.dart';

import '../models/quick_diagnosis.dart';
import '../utils/helpers/constant_variables.dart';

class DiagnosisService {
  Future<List<Patient>> getPatientsNoAssigned() async {
    try {
      var response = await http.get(
        Uri.parse(
            "${authURL}patients/medic/${prefs.idMedic}/get-patients-by-assigned/false"),
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

  Future<Diagnosis?> getDiagnosisId(int id) async {
    try {
      http.Response result = await http.get(
        Uri.parse("${authURL}diagnosis/$id"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      if (result.statusCode == 200) {
        print(result.body);
        final jsonResponse = json.decode(utf8.decode(result.bodyBytes));
        return Diagnosis.fromJson(jsonResponse);
      }
    } on SocketException catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<int> createDiagnosisMedic(Uint8List imageBytes, int idPatient) async {
    const url = '${authURL}diagnosis/create-diagnosis';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    final multipartFile = http.MultipartFile.fromBytes('file', imageBytes,
        filename: prefs.imageDiag, contentType: MediaType('image', 'jpeg'));
    request.headers['Authorization'] = 'Bearer ${prefs.token}';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['patientId'] = idPatient.toString();
    request.fields['creatorId'] = prefs.idMedic.toString();
    request.fields['creatorType'] = 'MEDIC';
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 201) {
      print('Image uploaded successfully!');
      final jsonResponse = json.decode(await response.stream.bytesToString());
      int id = jsonResponse['id'];
      print("El id del diagnóstico es: " + id.toString());
      return id;
    } else {
      print('Error uploading image. Status code: ${response.statusCode}');
      return 0;
    }
  }

  QuickDiagnosis quickDiagnosis = QuickDiagnosis();
  Future<QuickDiagnosis> createQuickDiagnosis(
      Uint8List imageBytes, BuildContext context) async {
    const url = '${authURL}diagnosis/quick-diagnosis';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    final multipartFile = http.MultipartFile.fromBytes('file', imageBytes,
        filename: prefs.imageQuickDiag,
        contentType: MediaType('image', 'jpeg'));
    request.headers['Authorization'] = 'Bearer ${prefs.token}';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(multipartFile);
    final response = await request
        .send()
        .timeout(Duration(seconds: 10))
        .then((value) => value)
        .catchError((onError) {
      print(onError);
      return mostrarAlertaError(context,
          "¡Ups! Hubo un problema al momento de realizar la operación, reintenta el diagnóstico",
          () {
        Navigator.pop(context);
      });
    });

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      print(jsonResponse);
      final quickDiagnosis = quickDiagnosisFromJson(jsonResponse);
      print(quickDiagnosis);
      return quickDiagnosis;
    } else {
      print('Error uploading image. Status code: ${response.statusCode}');
      return QuickDiagnosis();
    }
  }

  Future<int> createDiagnosisNurse(Uint8List imageBytes, int idPatient) async {
    const url = '${authURL}diagnosis/create-diagnosis';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    final multipartFile = http.MultipartFile.fromBytes('file', imageBytes,
        filename: prefs.imageDiag, contentType: MediaType('image', 'jpeg'));
    request.headers['Authorization'] = 'Bearer ${prefs.token}';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['patientId'] = idPatient.toString();
    request.fields['creatorId'] = prefs.idNurse.toString();
    request.fields['creatorType'] = 'NURSE';
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 201) {
      print('Image uploaded successfully!');
      final jsonResponse = json.decode(await response.stream.bytesToString());
      int id = jsonResponse['id'];
      print("El id del diagnóstico es: " + id.toString());
      return id;
    } else {
      print('Error uploading image. Status code: ${response.statusCode}');
      return 0;
    }
  }

  Future<void> confirmDiagnosticMedic(
      BuildContext context, int idDiagnosis) async {
    try {
      http.Response result = await http.post(
        Uri.parse("${authURL}diagnosis/confirm-diagnosis-medic/$idDiagnosis"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      if (result.statusCode == 200) {
        print("Se confirmó el diagnostico");
      } else {
        print("Hubo un error");
      }
    } on SocketException catch (e) {
      print(e);
      return;
    }
    return;
  }

  Future<void> confirmDiagnosticNurse(
      BuildContext context, int idDiagnosis) async {
    try {
      http.Response result = await http.post(
        Uri.parse("${authURL}diagnosis/confirm-diagnosis-nurse/$idDiagnosis"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.token}",
        },
      );
      if (result.statusCode == 200) {
        print("Se confirmó el diagnostico");
      } else {
        print("Hubo un error");
      }
    } on SocketException catch (e) {
      print(e);
      return;
    }
    return;
  }

  Future<List<Diagnosis>> getDiagnosisByMedicCMP(String? cmp,
      {String? query, String? query2}) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}diagnosis/get-by-medic-cmp/$cmp"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Diagnosis> diagnosis =
            body.map((dynamic item) => Diagnosis.fromJson(item)).toList();
        if (query != null) {
          diagnosis = diagnosis
              .where((element) => element.patientName
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        } else if (query2 != null) {
          diagnosis = diagnosis
              .where((element) => element.stagePredicted
                  .toLowerCase()
                  .contains(query2.toLowerCase()))
              .toList();
        }
        print(body);
        return diagnosis;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Diagnosis>> getDiagnosisByNurseCEP(String cep,
      {String? query, String? query2, String? state}) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}diagnosis/get-by-nurse-cep/$cep"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Diagnosis> diagnosis =
            body.map((dynamic item) => Diagnosis.fromJson(item)).toList();
        if (query != null) {
          diagnosis = diagnosis
              .where((element) => element.patientName
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        } else if (query2 != null) {
          diagnosis = diagnosis
              .where((element) => element.stagePredicted
                  .toLowerCase()
                  .contains(query2.toLowerCase()))
              .toList();
        }
        print(body);
        return diagnosis;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Diagnosis>> getDiagnosisByCMPByStage(String? cmp, String stage,
      {String? query}) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}diagnosis/medic-cmp/$cmp/stage-predicted/$stage"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Diagnosis> diagnosis =
            body.map((dynamic item) => Diagnosis.fromJson(item)).toList();
        if (query != null) {
          diagnosis = diagnosis
              .where((element) => element.stagePredicted
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
        print(body);
        return diagnosis;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Diagnosis>> getDiagnosisByCEPByStage(String? cep, String stage,
      {String? query}) async {
    try {
      var response = await http.get(
        Uri.parse("${authURL}diagnosis/nurse-cep/$cep/stage-predicted/$stage"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${prefs.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        List<Diagnosis> diagnosis =
            body.map((dynamic item) => Diagnosis.fromJson(item)).toList();
        if (query != null) {
          diagnosis = diagnosis
              .where((element) => element.patientName
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }
        print(body);
        return diagnosis;
      } else {
        throw Exception("Failed to load data");
      }
    } on SocketException catch (e) {
      print(e);
      return [];
    }
  }
}
