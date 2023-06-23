// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/first_page.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/fourth_page.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/second_page.dart';
import 'package:ulcernosis/pages/home/tab_bar_pages/third_page.dart';

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
          'Etapa',
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
          'Etapa',
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
          'Etapa',
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
          'Etapa',
          style: TextStyle(fontSize: 12),
        ),
      ),
    ];
    return DefaultTabController(
        length: 4,
        child: SafeArea(
          child: Scaffold(
            body: NestedScrollView(
              //physics: NeverScrollableScrollPhysics(),
              floatHeaderSlivers: true,
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 16, bottom: 16),
                      child: ElevatedButton(
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Theme.of(context).colorScheme.onTertiary,
                          size: 18,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer), // <-- Button color
                        ),
                      ),
                    ),
                    leadingWidth: 96,
                    toolbarHeight: 98,
                    title: Text('Filtrado por Etapa',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                    centerTitle: true,
                    backgroundColor: Theme.of(context).colorScheme.onTertiary,
                    elevation: 10.0,
                    pinned: false,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      controller: tabController,
                      tabs: tabss,
                      indicator: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .tertiary, // <-- label color
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
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: const [
                            //Primera Etapa
                            Tab(
                              child: FirstPage(),
                            ),
                            //Segunda Etapa
                            Tab(child: SecondPage()),
                            //Tercera Etapa
                            Tab(
                              child: ThirdPage(),
                            ),
                            //Cuarta Etapa
                            Tab(
                              child: FourthPage(),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
        ));
  }
}
