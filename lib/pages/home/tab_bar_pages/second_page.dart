import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/services/diagnosis_service.dart';

import '../../../models/nurse.dart';
import '../../../models/users.dart';
import '../../../services/medic_service.dart';
import '../../../services/nurse_services.dart';
import '../../../services/users_service.dart';
import '../../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../../utils/helpers/Searchable/searchable_widget.dart';
import '../../../utils/helpers/constant_variables.dart';
import '../../../utils/helpers/Searchable/searchable_medic.dart';
import '../../../utils/helpers/future_builder_cards/future_builders_filter.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
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
          await diagnosisService.getDiagnosisByCMPByStage(medic.cmp, "2");
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      diagnosis =
          await diagnosisService.getDiagnosisByCEPByStage(nurse.cep, "2");
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
                : SearchableTitle(
                    title: "Buscar por etapa 2...",
                    onChanged: () async {
                      await showSearch(
                          context: context,
                          delegate: user.role == "ROLE_MEDIC"
                              ? SearchUser(
                                  isHome: false,
                                  cmp: medic.cmp,
                                  isEtapa: true,
                                  stagePredicted: "2")
                              : SearchNurse(
                                  isHome: false,
                                  cep: nurse.cep,
                                  isEtapa: true,
                                  stagePredicted: "2"));
                    },
                  ),
            const SizedBox(height: 16),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.18,
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
                              height: 16,
                            ),
                            const Text(
                                "No se encontraron registros de diagnósticos disponibles",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(213, 213, 213, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      );
                    })
                : user.role == "ROLE_MEDIC"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyFutureBuilderFilter(
                          myFuture: diagnosisService.getDiagnosisByCMPByStage(
                              medic.cmp, "2"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MyFutureBuilderFilter(
                          myFuture: diagnosisService.getDiagnosisByCEPByStage(
                              nurse.cep, "2"),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
