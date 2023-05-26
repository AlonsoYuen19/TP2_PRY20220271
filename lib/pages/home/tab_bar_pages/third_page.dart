import 'package:flutter/material.dart';
import '../../../models/diagnosis.dart';
import '../../../models/medic.dart';
import '../../../models/nurse.dart';
import '../../../models/users.dart';
import '../../../services/diagnosis_service.dart';
import '../../../services/medic_service.dart';
import '../../../services/nurse_services.dart';
import '../../../services/users_service.dart';
import '../../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../../utils/helpers/constant_variables.dart';

import '../../../utils/helpers/Searchable/searchable_medic.dart';
import '../../../utils/helpers/future_builder_cards/future_builders_filter.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final diagnosisService = DiagnosisService();
  final medicService = MedicAuthServic();
  final userService = UsersAuthService();
  final nurseService = NurseAuthService();
  List<Diagnosis> diagnosis = [];
  Medic medic = Medic();
  Users user = Users();
  Nurse nurse = Nurse();
  Future init() async {
    user = (await userService.getUsersById())!;
    if (user.role == "ROLE_MEDIC") {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCMPByStage(medic.cmp, "3");
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCEPByStage(nurse.cep, "3");
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
    return Scaffold(
      body: ListView(
        children: [
          diagnosis.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          "Seleccione el icono de búsqueda\npara filtrar por nombres del\npaciente",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              )),
                            ),
                            onPressed: () async {
                              await showSearch(
                                  context: context,
                                  delegate: user.role == "ROLE_MEDIC"
                                      ? SearchUser(
                                          isHome: false,
                                          cmp: medic.cmp,
                                          isEtapa: true,
                                          stagePredicted: "3")
                                      : SearchNurse(
                                          isHome: false,
                                          cep: nurse.cep,
                                          isEtapa: true,
                                          stagePredicted: "3"));
                            },
                            icon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.onTertiary,
                              size: 30,
                            )),
                      )
                    ],
                  ),
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
                            height: MediaQuery.of(context).size.height * 0.1),
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 0, color: Colors.transparent),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/out-stock-diagnostico.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                              "No hay Registros de Diagnósticos Disponibles",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    );
                  })
              : user.role == "ROLE_MEDIC"
                  ? MyFutureBuilderFilter(
                      myFuture: diagnosisService.getDiagnosisByCMPByStage(
                          medic.cmp, "3"),
                    )
                  : MyFutureBuilderFilter(
                      myFuture: diagnosisService.getDiagnosisByCEPByStage(
                          nurse.cep, "3"),
                    ),
        ],
      ),
    );
  }
}
