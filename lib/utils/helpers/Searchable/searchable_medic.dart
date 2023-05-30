import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
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
    final size = MediaQuery.of(context).size;
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
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  if (data![index].stagePredicted == "1") {
                    categoria = "Etapa: 1";
                  } else if (data[index].stagePredicted == "2") {
                    categoria = "Etapa: 2";
                  } else if (data[index].stagePredicted == "3") {
                    categoria = "Etapa: 3";
                  } else if (data[index].stagePredicted == "4") {
                    categoria = "Etapa: 4";
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DiagnosisPageByPatient(
                                    idDiagnosis: data[index].id,
                                    idPatient: data[index].patientId,
                                  )));
                    },
                    child: Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.only(bottom: 5, top: 15),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: Card(
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
                                    isHome
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
