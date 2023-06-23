//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/patient_service.dart';
import '../../../models/diagnosis.dart';
import '../../../pages/home/diagnosis_page_patient.dart';
import '../../../services/diagnosis_service.dart';
import '../constant_variables.dart';

class MyFutureBuilderFilter extends StatefulWidget {
  final Future<List> myFuture;
  MyFutureBuilderFilter({super.key, required this.myFuture});

  @override
  State<MyFutureBuilderFilter> createState() => _MyFutureBuilderState();
}

class _MyFutureBuilderState extends State<MyFutureBuilderFilter> {
  String categoria = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: widget.myFuture,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var data = snapshot.data ?? [];

        return ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            physics: const BouncingScrollPhysics(),
            //itemCount: widget.isHome ? 4 : data.length,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              int reversedIndex = data.length - 1 - index;
              if (snapshot.connectionState == ConnectionState.waiting) {
                Future.delayed(const Duration(seconds: 1));
                return Center(
                    child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(color: Colors.transparent),
                ));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error al cargar los datos",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary),
                  ),
                );
              }

              if (data[reversedIndex].stagePredicted == "1") {
                categoria = "1";
              } else if (data[reversedIndex].stagePredicted == "2") {
                categoria = "2";
              } else if (data[reversedIndex].stagePredicted == "3") {
                categoria = "3";
              } else if (data[reversedIndex].stagePredicted == "4") {
                categoria = "4";
              }
              String anio2 = data[index].createdAt.substring(0, 4);
              String mes2 = data[index].createdAt.substring(5, 7);
              String dia2 = data[index].createdAt.substring(8, 10);
              mes2 = meses[mes2]!;
              return GestureDetector(
                onTap: () async {
                  DiagnosisService diagnosisService = DiagnosisService();
                  Diagnosis? diagnosis =
                      await diagnosisService.getDiagnosisId(data[index].id);
                  PatientService patientService = PatientService();
                  Patient? patient = await patientService
                      .getPatientByIdDiagnosis(data[index].patientId);
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
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 1,
                    ),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              ExactAssetImage("assets/images/patient-logo.png"),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${data[index].patientName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                            const SizedBox(height: 6),
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
                            const SizedBox(height: 6),
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
                                  "$mes2 $dia2, $anio2",
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
      },
    );
  }
}
