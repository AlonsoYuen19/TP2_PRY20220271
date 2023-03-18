import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/models/medic.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/services/nurse_services.dart';
import 'package:ulcernosis/services/users_service.dart';
import 'package:ulcernosis/utils/providers/auth_token.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';
import 'package:ulcernosis/utils/helpers/Searchable/searchable.dart';

import '../../services/medic_service.dart';
import '../../utils/helpers/appbar_drawer.dart';
import '../../utils/helpers/future_builders.dart';
import '../../utils/helpers/loaders_screens/loader_home_screen.dart';
import '../../utils/widgets/alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final userAuth = MedicAuthServic();
  final userAuth = UsersAuthService();
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
            return AppBarDrawer(isHome: true, child: homePage());
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
            "Últimos Diagnósticos",
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
        Expanded(
          child: Container(
            height: 520,
            padding: const EdgeInsets.only(top: 20),
            child: MyFutureBuilder(
              myFuture: userAuth.getUsers(),
              isHome: true,
            ),
          ),
        )
      ],
    );
  }
}
