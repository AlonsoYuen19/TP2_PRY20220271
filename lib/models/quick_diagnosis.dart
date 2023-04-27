import 'dart:convert';

QuickDiagnosis quickDiagnosisFromJson(String str) => QuickDiagnosis.fromJson(json.decode(str));
String diagnosisToJson(QuickDiagnosis data) => json.encode(data.toJson());

class QuickDiagnosis {
  QuickDiagnosis({
    this.stage1 = "",
    this.stage2 = "",
    this.stage3 = "",
    this.stage4 = "",
    this.stagePredicted = "",
    this.creatorType = "",
  });

  String stage1;
  String stage2;
  String stage3;
  String stage4;
  String stagePredicted;
  String creatorType;

  factory QuickDiagnosis.fromJson(Map<String, dynamic> json) => QuickDiagnosis(
        stage1: json["stage_1"],
        stage2: json["stage_2"],
        stage3: json["stage_3"],
        stage4: json["stage_4"],
        stagePredicted: json["stage_predicted"],
        creatorType: json["creatorType"],
      );
  Map<String, dynamic> toJson() => {
        "stage_1": stage1,
        "stage_2": stage2,
        "stage_3": stage3,
        "stage_4": stage4,
        "stage_predicted": stagePredicted,
        "creatorType": creatorType,
      };
}