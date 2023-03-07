import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/utils/helpers/appbar_drawer/appbar_drawer_nurse.dart';
import 'package:ulcernosis/utils/providers/auth_token.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/helpers/searchable.dart';

import '../../../services/medic_service.dart';
import '../../../utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../../utils/widgets/alert_dialog.dart';

class HomeNurseScreen extends StatefulWidget {
  const HomeNurseScreen({super.key});

  @override
  State<HomeNurseScreen> createState() => _HomeNurseScreenState();
}

class _HomeNurseScreenState extends State<HomeNurseScreen> {
  final userAuth = MedicAuthServic();
  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(Container());
    });

    return completer.future;
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
            return AppBarDrawerNurse(isHome: true, child: homePage());
          },
        ));
  }

  Widget homePage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Deseas filtrar por categorías?",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey),
            ),
            TextButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateToken(context);
                  Navigator.pushNamed(context, 'tabBarFilter');
                },
                child: Text("Filtrar",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: paddingListViewHori + 14,
              vertical: paddingListViewVerti),
          child: Text(
            "Últimos Diagnósticoss",
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        Padding(
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
                      .copyWith(color: Colors.grey),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
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
                      Provider.of<AuthProvider>(context, listen: false)
                          .updateToken(context);
                      await showSearch(
                        context: context,
                        delegate: SearchUser(isHome: true),
                      );
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
        /*Expanded(
          child: Container(
            height: 520,
            padding: const EdgeInsets.only(top: 20),
            child: MyFutureBuilder(
              myFuture: userAuth.getMedics(),
              isHome: true,
            ),
          ),
        )*/
      ],
    );
  }
}
