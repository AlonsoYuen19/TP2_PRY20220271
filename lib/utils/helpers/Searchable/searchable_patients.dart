import 'package:flutter/material.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/patient_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import '../../../pages/profile/patient_profile.dart';
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
          future: _patientList.getPatientsByMedics(query: query),
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
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 24),
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
                  mes = meses[mes];
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, left: 15, right: 15, top: 15),
                    child: FancyCardSearchPatient(
                      image: Image.asset("assets/images/patient-logo.png"),
                      title: snapshot.data![index].fullName,
                      date: snapshot.data![index].email,
                      date2: "$dia de $mes del $anio",
                      function: () {
                        prefs.idPatient = snapshot.data![index].id;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientProfileScreen(),
                          ),
                        );
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
