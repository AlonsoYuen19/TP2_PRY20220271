import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ulcernosis/models/diagnosis.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/services/diagnosis_service.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/helpers/Searchable/searchable_medic.dart';
import '../../utils/helpers/Searchable/searchable_nurse.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/future_builder_cards/future_builders.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../utils/widgets/alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final diagnosisService = DiagnosisService();
  final userAuth = UsersAuthService();
  final nurseService = NurseAuthService();
  final medicService = MedicAuthServic();
  Diagnosis diagnosis = Diagnosis();
  Users user = Users();
  Nurse nurse = Nurse();
  Medic medic = Medic();
  List<Diagnosis> listDiagnosis = [];
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Future init() async {
    user = (await userAuth.getUsersById())!;
    if (user.role == "ROLE_MEDIC") {
      medic = (await medicService.getMedicById(prefs.idMedic.toString()))!;
      listDiagnosis =
          (await diagnosisService.getDiagnosisByMedicCMP(medic.cmp));
    } else {
      nurse = (await nurseService.getNurseByIdManage(prefs.idNurse))!;
      listDiagnosis =
          (await diagnosisService.getDiagnosisByNurseCEP(nurse.cep));
    }
    setState(() {
      print("El usuario es: ${user.fullName}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: ((context) => const CustomDialogWidget()));
          return false;
        },
        child: FutureBuilder(
          future: delayPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoaderHomeScreen();
            }
            return AppBarDrawer(
                isHome: true, title: "Últimos Diagnósticos", child: homePage());
          },
        ));
  }

  Widget homePage() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Deseas filtrar por etapas?",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'tabBarFilter');
                  },
                  child: Text("Filtrar",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Text(
                  "Seleccione el icono de búsqueda\npara filtrar, de acuedo al nombre\ndel paciente",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16.5),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(const CircleBorder()),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      )),
                    ),
                    onPressed: () async {
                      await showSearch(
                          context: context,
                          delegate: user.role == "ROLE_MEDIC"
                              ? SearchUser(
                                  isHome: true, cmp: medic.cmp, isEtapa: false)
                              : SearchNurse(
                                  isHome: true,
                                  cep: nurse.cep,
                                  isEtapa: false));
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 30,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          listDiagnosis.isEmpty
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
                          height: size.height * 0.05,
                        ),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                              "No hay Registros de Diagnósticos Disponibles",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    );
                  })
              : user.role == "ROLE_MEDIC"
                  ? MyFutureBuilder(
                      myFuture:
                          diagnosisService.getDiagnosisByMedicCMP(medic.cmp),
                      isHome: true,
                    )
                  : MyFutureBuilder(
                      myFuture:
                          diagnosisService.getDiagnosisByNurseCEP(nurse.cep),
                      isHome: true,
                    ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
