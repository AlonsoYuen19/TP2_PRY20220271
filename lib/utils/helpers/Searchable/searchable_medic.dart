import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/services/patient_service.dart';
import '../../../models/patient.dart';
import '../../../pages/home/diagnosis_page_patient.dart';
import '../../../services/diagnosis_service.dart';
import '../constant_variables.dart';

class SearchUser extends SearchDelegate {
  final diagnosisService = DiagnosisService();
  bool isHome = true;
  bool isEtapa = false;
  String? state = "";
  String? cmp;
  String? stagePredicted;
  SearchUser(
      {required this.isHome,
      this.state,
      this.cmp,
      this.stagePredicted,
      required this.isEtapa});
  @override
  String get searchFieldLabel => 'Buscar nombre del paciente';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      isEtapa == true
          ? IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.close))
          : IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.close_fullscreen))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<Diagnosis>>(
          future: isHome && isEtapa == false
              ? diagnosisService.getDiagnosisByMedicCMP(cmp!, query: query)
              : /*_userList.getDoctorsByStateCivil(state!, query: query),*/
              //diagnosisService.getDiagnosisByMedicCMP(cmp, query: query),
              diagnosisService.getDiagnosisByCMPByStage(
                  cmp!,
                  stagePredicted!,
                  query: query,
                ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '! Por favor, ingrese el nombre del paciente correctamente ... ! ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        )
                        .copyWith(fontSize: 24),
                  ),
                ),
              );
            }
            List<Diagnosis>? data = snapshot.data;
            String categoria = "";
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                physics: const BouncingScrollPhysics(),
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  if (data[index].stagePredicted == "1") {
                    categoria = "1";
                  } else if (data[index].stagePredicted == "2") {
                    categoria = "2";
                  } else if (data[index].stagePredicted == "3") {
                    categoria = "3";
                  } else if (data[index].stagePredicted == "4") {
                    categoria = "4";
                  }
                  String anio = data[index].createdAt.substring(0, 4);
                  String mes = data[index].createdAt.substring(5, 7);
                  String dia = data[index].createdAt.substring(8, 10);
                  mes = meses[mes]!;
                  String anio2 = data[index].createdAt.substring(0, 4);
                  String mes2 = data[index].createdAt.substring(5, 7);
                  String dia2 = data[index].createdAt.substring(8, 10);
                  mes2 = meses[mes2]!;
                  return GestureDetector(
                    onTap: () async{
                      DiagnosisService diagnosisService = DiagnosisService();
                  Diagnosis? diagnosis = await diagnosisService.getDiagnosisId(data[index].id);
                      PatientService patientService = PatientService();
                      Patient? patient = await patientService.getPatientByIdDiagnosis(data[index].patientId);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiagnosisPageByPatient(
                                    idDiagnosis: data[index].id,
                                    idPatient: data[index].patientId,
                                    diagnosis: diagnosis,
                                    patient: patient,
                                  )));
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                          width: 1,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16, bottom: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              backgroundImage: ExactAssetImage(
                                  "assets/images/patient-logo.png"),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    isHome
                                        ? data[index].patientName
                                        : data[index].patientName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                Row(
                                  children: [
                                    Text(
                                      "Etapa: ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      categoria,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Fecha: ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      isHome
                                          ? "$mes $dia, $anio"
                                          : "$mes2 $dia2, $anio2",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        width: 70,
        child: CircularProgressIndicator(
          strokeWidth: 10,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
