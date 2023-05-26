//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../pages/home/diagnosis_page_patient.dart';
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
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];

          return ListView.builder(
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
                  categoria = "1era Etapa";
                } else if (data[reversedIndex].stagePredicted == "2") {
                  categoria = "2da Etapa";
                } else if (data[reversedIndex].stagePredicted == "3") {
                  categoria = "3era Etapa";
                } else if (data[reversedIndex].stagePredicted == "4") {
                  categoria = "4ta Etapa";
                }
                String anio2 = data[index].createdAt.substring(0, 4);
                String mes2 = data[index].createdAt.substring(5, 7);
                String dia2 = data[index].createdAt.substring(8, 10);
                mes2 = meses[mes2]!;
                return Container(
                  width: size.width * 0.9,
                  padding: const EdgeInsets.only(bottom: 5, top: 15),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Card(
                    semanticContainer: true,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 20,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text('${data[index].patientName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DiagnosisPageByPatient(
                                                idDiagnosis:
                                                    data[reversedIndex].id,
                                                idPatient: data[reversedIndex]
                                                    .patientId,
                                              )));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: ImageIcon(
                                    AssetImage("assets/images/search-icon.png"),
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/images/category-icon.png"),
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 36,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                categoria,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 36,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "$dia2 de $mes2 del $anio2",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
