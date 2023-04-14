// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/first_page.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/fourth_page.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/second_page.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/third_page.dart';

import '../../models/medic.dart';
import '../../services/medic_service.dart';
import '../../shared/user_prefs.dart';

class TabBarFilter extends StatefulWidget {
  const TabBarFilter({Key? key}) : super(key: key);

  @override
  State<TabBarFilter> createState() => _TabBarFilterState();
}

class _TabBarFilterState extends State<TabBarFilter>
    with TickerProviderStateMixin {
  /*Medic doctorUser = Medic();
  final userAuth = MedicAuthServic();
  final prefs = SaveData();*/
  ScrollController _scrollController = ScrollController();

  /*Future init() async {
    var userId = await userAuth.getAuthenticateId(prefs.email, prefs.password);
    doctorUser = (await userAuth.getMedicById(userId.toString()))!;
    setState(() {
      print("El usuario con info es el siguiente :${doctorUser.fullName}");
      print("El usuario con id es el siguiente :" + userId!.toString());
    });
  }*/

  @override
  void initState() {
    //init();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Widget> delayPage() {
    Completer<Widget> completer = Completer();
    Future.delayed(const Duration(milliseconds: 200), () {
      completer.complete(Container());
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    final tabss = [
      const Tab(
        iconMargin: EdgeInsets.only(bottom: 5),
        icon: Icon(
          Icons.looks_one,
          size: 32,
        ),
        child: Text(
          'Categoria',
          style: TextStyle(fontSize: 12),
        ),
      ),
      const Tab(
        iconMargin: EdgeInsets.only(bottom: 5),
        icon: Icon(
          Icons.looks_two,
          size: 32,
        ),
        child: Text(
          'Categoria',
          style: TextStyle(fontSize: 12),
        ),
      ),
      const Tab(
        iconMargin: EdgeInsets.only(bottom: 5),
        icon: Icon(
          Icons.looks_3,
          size: 32,
        ),
        child: Text(
          'Categoria',
          style: TextStyle(fontSize: 12),
        ),
      ),
      const Tab(
        iconMargin: EdgeInsets.only(bottom: 5),
        icon: Icon(
          Icons.looks_4,
          size: 32,
        ),
        child: Text(
          'Categoria',
          style: TextStyle(fontSize: 12),
        ),
      ),
    ];
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height * 0.11,
                  title: const Text('Filtrado por Categoría'),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.onTertiary,
                  elevation: 10.0,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    controller: tabController,
                    tabs: tabss,
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                  ),
                )
              ];
            },
            body: SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                  future: delayPage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: tabController,
                        children: const [
                          //Primera categoria
                          Tab(
                            child: FirstPage(),
                          ),
                          //Segunda categoria
                          Tab(child: SecondPage()),
                          //Tercera categoria
                          Tab(
                            child: ThirdPage(),
                          ),
                          //Cuarta categoria
                          Tab(
                            child: FourthPage(),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                              color: Colors.lightBlue),
                        ),
                      );
                    }
                  }),
            ),
          ),
        ));
  }
}
