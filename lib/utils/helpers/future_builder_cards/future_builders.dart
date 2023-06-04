//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../pages/home/diagnosis_page_patient.dart';
import '../constant_variables.dart';

class MyFutureBuilder extends StatefulWidget {
  final Future<List> myFuture;
  bool isHome = true;
  MyFutureBuilder({super.key, required this.myFuture, this.isHome = true});

  @override
  State<MyFutureBuilder> createState() => _MyFutureBuilderState();
}

class _MyFutureBuilderState extends State<MyFutureBuilder> {
  String categoria = "";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];

          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              //itemCount: widget.isHome ? 4 : data.length,
              shrinkWrap: true,
              itemCount: data.length > 4 ? 4 : data.length,
              itemBuilder: (context, index) {
                int reversedIndex = data.length - 1 - index;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Future.delayed(const Duration(seconds: 1));
                  return Center(
                      child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
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
                  categoria = "Etapa: 1";
                } else if (data[reversedIndex].stagePredicted == "2") {
                  categoria = "Etapa: 2";
                } else if (data[reversedIndex].stagePredicted == "3") {
                  categoria = "Etapa: 3";
                } else if (data[reversedIndex].stagePredicted == "4") {
                  categoria = "Etapa: 4";
                }
                String anio = data[reversedIndex].createdAt.substring(0, 4);
                String mes = data[reversedIndex].createdAt.substring(5, 7);
                String dia = data[reversedIndex].createdAt.substring(8, 10);
                mes = meses[mes]!;
                String anio2 = data[index].createdAt.substring(0, 4);
                String mes2 = data[index].createdAt.substring(5, 7);
                String dia2 = data[index].createdAt.substring(8, 10);
                mes2 = meses[mes2]!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiagnosisPageByPatient(
                                  idDiagnosis: data[reversedIndex].id,
                                  idPatient: data[reversedIndex].patientId,
                                )));
                  },
                  child: Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.only(bottom: 5, top: 15),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.background,
                          width: 1,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              backgroundImage: ExactAssetImage(
                                  "assets/images/patient-logo.png"),
                            ),
                            SizedBox(width: size.width * 0.05),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.02),
                                Text(
                                    widget.isHome
                                        ? '${data[reversedIndex].patientName}'
                                        : '${data[index].patientName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(
                                  categoria,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.isHome
                                      ? "Fecha: $mes $dia, $anio"
                                      : "Fecha: $mes2 $dia2, $anio2",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: size.height * 0.015),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
