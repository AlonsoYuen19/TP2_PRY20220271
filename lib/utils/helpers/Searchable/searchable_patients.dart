import 'package:flutter/material.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/patient_service.dart';
import '../../widgets/fancy_card.dart';

class SearchUserPatient extends SearchDelegate {
  final PatientService _patientList = PatientService();
  String? state = "";
  final bool isMedic;
  SearchUserPatient({this.state, required this.isMedic});
  @override
  String get searchFieldLabel => 'Buscar nombre del paciente';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
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
      child: FutureBuilder<List<Patient>>(
          future: isMedic == true
              ? _patientList.getPatientsByMedics(query: query)
              : _patientList.getPatientsByNurse(query: query),
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
                child: Text(
                  'No se encontraron pacientes relacionados',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              );
            }
            if (searchFieldLabel == "") {
              return Center(
                child: Text(
                  'Escribe bien el nombre del paciente',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              );
            }
            List<Patient>? data = snapshot.data;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  String anio = data![index].createdAt.substring(0, 4);
                  String mes = data[index].createdAt.substring(5, 7);
                  String dia = data[index].createdAt.substring(8, 10);
                  List<String> fecha = [];
                  fecha =
                      fecha.map((e) => e.replaceAll("01", "Enero")).toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("02", "Febrero")).toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("03", "Marzo")).toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("04", "Abril")).toList();
                  fecha = fecha.map((e) => e.replaceAll("05", "Mayo")).toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("06", "Junio")).toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("07", "Julio")).toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("08", "Agosto")).toList();
                  fecha = fecha
                      .map((e) => e.replaceAll("09", "Septiembre"))
                      .toList();
                  fecha =
                      fecha.map((e) => e.replaceAll("10", "Octubre")).toList();
                  fecha = fecha
                      .map((e) => e.replaceAll("11", "Noviembre"))
                      .toList();
                  fecha = fecha
                      .map((e) => e.replaceAll("12", "Diciembre"))
                      .toList();
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, left: 15, right: 15, top: 15),
                    child: FancyCardSearchPatient(
                      image: Image.asset("assets/images/patient-logo.png"),
                      title: snapshot.data![index].fullName,
                      date: snapshot.data![index].email,
                      date2: "$dia de $mes del $anio",
                      function: () {
                        //id para enviar a la siguiente pantalla
                        /*prefs.idPatient = snapshot.data![index].id;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientProfileScreen(),
                              ),
                            );*/
                      },
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
