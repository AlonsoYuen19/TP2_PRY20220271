import 'package:flutter/material.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/services/medic_service.dart';
import '../../../models/diagnosis.dart';
import '../../../services/diagnosis_service.dart';

import '../../../services/nurse_services.dart';
import '../../../services/users_service.dart';
import '../../../utils/helpers/Searchable/searchable_medic.dart';
import '../../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../../utils/helpers/constant_variables.dart';
import '../../../utils/helpers/future_builder_cards/future_builders_filter.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final diagnosisService = DiagnosisService();
  final medicService = MedicAuthServic();
  final userService = UsersAuthService();
  final nurseService = NurseAuthService();
  List<Diagnosis> diagnosis = [];
  List<Diagnosis> diagnosisCEP = [];
  Medic medic = Medic();
  Users user = Users();
  Nurse nurse = Nurse();
  Future init() async {
    user = (await userService.getUsersById())!;
    if (user.role == "ROLE_MEDIC") {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCMPByStage(medic.cmp, "1");
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCEPByStage(nurse.cep, "1");
    }

    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            diagnosis.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Realice la búsqueda de un paciente",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: IconButton(
                              onPressed: () async {
                                await showSearch(
                                    context: context,
                                    delegate: user.role == "ROLE_MEDIC"
                                        ? SearchUser(
                                            isHome: false,
                                            cmp: medic.cmp,
                                            isEtapa: true,
                                            stagePredicted: "1")
                                        : SearchNurse(
                                            isHome: false,
                                            cep: nurse.cep,
                                            isEtapa: true,
                                            stagePredicted: "1"));
                              },
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 17.49,
                              )),
                        )
                      ],
                    ),
                  ),
            const SizedBox(
              height: 16,
            ),
            diagnosis.isEmpty
                ? FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.transparent,
                        ));
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.15,
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            child: Image.asset(
                              'assets/images/Group.png',
                              color: Colors.grey,
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                              "No se encontraron registros de diagnósticos disponibles",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(213, 213, 213, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))
                        ],
                      );
                    })
                : user.role == "ROLE_MEDIC"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0),
                        child: MyFutureBuilderFilter(
                          myFuture: diagnosisService.getDiagnosisByCMPByStage(
                              medic.cmp, "1"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyFutureBuilderFilter(
                          myFuture: diagnosisService.getDiagnosisByCEPByStage(
                              nurse.cep, "1"),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
