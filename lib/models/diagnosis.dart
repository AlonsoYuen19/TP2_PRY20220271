import 'dart:convert';

Diagnosis diagnosisFromJson(String str) => Diagnosis.fromJson(json.decode(str));

String diagnosisToJson(Diagnosis data) => json.encode(data.toJson());

class Diagnosis {
  Diagnosis({
    this.id = 0,
    this.stage1 = "",
    this.stage2 = "",
    this.stage3 = "",
    this.stage4 = "",
    this.stagePredicted = "",
    this.patientId = 0,
    this.patientName = "",
    this.creatorId = 0,
    this.creatorType = "",
    this.creatorName = "",
    this.createdAt = "",
    this.isConfirmed,
  });

  int id;
  String stage1;
  String stage2;
  String stage3;
  String stage4;
  String stagePredicted;
  int patientId;
  String patientName;
  int creatorId;
  String creatorType;
  String creatorName;
  String createdAt;
  bool? isConfirmed;

  factory Diagnosis.fromJson(Map<String, dynamic> json) => Diagnosis(
        id: json["id"],
        stage1: json["stage1"],
        stage2: json["stage2"],
        stage3: json["stage3"],
        stage4: json["stage4"],
        stagePredicted: json["stagePredicted"],
        patientId: json["patientId"],
        patientName: json["patientName"],
        creatorId: json["creatorId"],
        creatorType: json["creatorType"],
        creatorName: json["creatorName"],
        createdAt: json["createdAt"],
        isConfirmed: json["isConfirmed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stage1": stage1,
        "stage2": stage2,
        "stage3": stage3,
        "stage4": stage4,
        "stagePredicted": stagePredicted,
        "patientId": patientId,
        "patientName": patientName,
        "creatorId": creatorId,
        "creatorType": creatorType,
        "creatorName": creatorName,
        "createdAt": createdAt,
        "isConfirmed": isConfirmed,
      };
}
