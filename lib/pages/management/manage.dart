import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/services/users_service.dart';

import '../../services/team_work_service.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/future_builder_cards/future_builder_nurses_by_medic_tw.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../utils/widgets/alert_dialog.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 3), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  Users users = Users();
  List listNurses = [];
  Future init() async {
    final teamWorkService = TeamWorkService();
    final userServices = UsersAuthService();
    users = (await userServices.getUsersById())!;
    print("Rol del usuario: ${users.role}");
    if (users.role == "ROLE_MEDIC") {
      listNurses = await teamWorkService.getNursesByTeamWork();

      setState(() {
        print("El tamaño de la lista es: ${listNurses.length}");
      });
      if (listNurses.isEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          mostrarAlertaError(context,
              "Usted Actualmente, no\ntiene enfermeros. Por\nfavor, añada a enfermeros para que obtenga su equipo médico",
              () {
            Navigator.of(context).pop();
          });
        });
      } else {
        Future.delayed(const Duration(seconds: 2));
      }
    }
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
              return const LoaderScreen();
            }
            return AppBarDrawer(
                isManagement: true,
                title: "Gestión de Equipo Médico",
                child: users.role == "ROLE_MEDIC" ? managePage() : Container());
          },
        ));
  }

  Widget managePage() {
    final nurseAvailableService = TeamWorkService();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Lista de Enfermeros",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                listNurses.length < 3
                    ? Tooltip(
                        textStyle: TextStyle(fontSize: 15),
                        triggerMode: TooltipTriggerMode.tap,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        showDuration: Duration(seconds: 4),
                        message:
                            "Selecciona el icono para\nagregar enfermeros\na tu equipo médico",
                        child: Icon(Icons.info_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            size: 36))
                    : Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          listNurses.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyFutureBuilderNursesByMedicsTW(
                    myFuture: nurseAvailableService.getNursesByTeamWork(),
                  ),
                ),
          const SizedBox(
            height: 24,
          ),
          if (listNurses.length < 3) ...[
            cardNurseSelectorEmpty(),
          ] else ...[
            Container()
          ],
        ],
      ),
    );
  }

  Widget cardNurseSelectorEmpty() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'addNurse');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Añadir",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
