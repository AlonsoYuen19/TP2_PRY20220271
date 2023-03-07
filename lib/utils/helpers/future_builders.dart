//class future builder

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'constant_variables.dart';

class MyFutureBuilder extends StatefulWidget {
  final Future<List> myFuture;
  bool isHome = true;
  MyFutureBuilder({super.key, required this.myFuture, this.isHome = true});

  @override
  State<MyFutureBuilder> createState() => _MyFutureBuilderState();
}

class _MyFutureBuilderState extends State<MyFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder<List>(
        future: widget.myFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data ?? [];
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              //itemCount: widget.isHome ? 4 : data.length,
              itemCount: data.length,
              itemBuilder: (context, index) {
                int reversedIndex = data.length - index - 1;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Future.delayed(const Duration(seconds: 1));
                  return Center(
                      child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ));
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (data.isEmpty) {
                    return Center(
                      child: Text(
                        "No hay diagnósticos creados",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                    );
                  }
                }
                return Container(
                  width: size.width * 0.9,
                  padding: const EdgeInsets.only(bottom: 5),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Card(
                    semanticContainer: true,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 20,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.isHome
                                      ? '${data[reversedIndex].fullName}'
                                      : '${data[index].fullName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: ImageIcon(
                                  const AssetImage(
                                      "assets/images/search-icon.png"),
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              ImageIcon(
                                const AssetImage(
                                    "assets/images/category-icon.png"),
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 36,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Categoria 1",
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: paddingHori),
                          child: Row(
                            children: [
                              ImageIcon(
                                const AssetImage(
                                    "assets/images/address-icon.png"),
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.isHome
                                    ? '${data[reversedIndex].address}'
                                    : '${data[index].address}',
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
