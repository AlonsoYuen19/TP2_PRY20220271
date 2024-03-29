import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import '../../../models/patient.dart';
import '../../../pages/home/diagnosis_page_patient.dart';
import '../../../services/diagnosis_service.dart';
import '../../../services/patient_service.dart';
import '../constant_variables.dart';

class SearchNurse extends SearchDelegate {
  final diagnosisService = DiagnosisService();
  bool isHome = true;
  bool isEtapa = false;
  String? state = "";
  String? cep;
  String? stagePredicted;
  SearchNurse(
      {required this.isHome,
      this.state,
      this.cep,
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
              ? diagnosisService.getDiagnosisByNurseCEP(cep!, query: query)
              : diagnosisService.getDiagnosisByCEPByStage(cep!, stagePredicted!,
                  query: query),
          builder: (context, snapshot) {
            List<Diagnosis>? data = snapshot.data;

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

            String categoria = "";

            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  if (data![index].stagePredicted == "1") {
                    categoria = "1era Categoría";
                  } else if (data[index].stagePredicted == "2") {
                    categoria = "2da Categoría";
                  } else if (data[index].stagePredicted == "3") {
                    categoria = "3era Categoría";
                  } else if (data[index].stagePredicted == "4") {
                    categoria = "4ta Categoría";
                  }
                  String anio = data[index].createdAt.substring(0, 4);
                  String mes = data[index].createdAt.substring(5, 7);
                  String dia = data[index].createdAt.substring(8, 10);
                  mes = meses[mes]!;
                  String anio2 = data[index].createdAt.substring(0, 4);
                  String mes2 = data[index].createdAt.substring(5, 7);
                  String dia2 = data[index].createdAt.substring(8, 10);
                  mes2 = meses[mes2]!;
                  return Container(
                    width: size.width * 0.9,
                    padding: const EdgeInsets.only(bottom: 5),
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
                                  child: Text(
                                      isHome
                                          ? data[index].patientName
                                          : data[index].patientName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    DiagnosisService diagnosisService =
                                        DiagnosisService();
                                    Diagnosis? diagnosis =
                                        await diagnosisService
                                            .getDiagnosisId(data[index].id);
                                    PatientService patientService =
                                        PatientService();
                                    Patient? patient = await patientService
                                        .getPatientByIdDiagnosis(
                                            data[index].patientId);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiagnosisPageByPatient(
                                                  idDiagnosis: data[index].id,
                                                  idPatient:
                                                      data[index].patientId,
                                                  diagnosis: diagnosis,
                                                  patient: patient,
                                                )));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: ImageIcon(
                                      AssetImage(
                                          "assets/images/search-icon.png"),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
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
                                  isHome
                                      ? "$dia de $mes del $anio"
                                      : "$dia2 de $mes2 del $anio2",
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
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.tertiary,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
