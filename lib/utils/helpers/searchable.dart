import 'package:flutter/material.dart';
import 'package:ulcernosis/models/medic.dart';

import '../../services/medic_service.dart';
import 'constant_variables.dart';

class SearchUser extends SearchDelegate {
  final MedicAuthServic _userList = MedicAuthServic();
  bool isHome = true;
  String? state = "";
  SearchUser({required this.isHome, this.state});
  @override
  String get searchFieldLabel => 'Buscar nombre del paciente';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<Medic>>(
          future: isHome
              ? _userList.getMedics(query: query)
              : /*_userList.getDoctorsByStateCivil(state!, query: query),*/
              _userList.getMedics(query: query),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Escribe bien el nombre del paciente',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              );
            }
            if (searchFieldLabel == "") {
              return Center(
                child: Text(
                  'Escribe bien el nombre del paciente',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              );
            }
            List<Medic>? data = snapshot.data;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: size.width * 0.9,
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.only(left: paddingHori),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${data?[index].fullName}',
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
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
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
                                  '${data?[index].address}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
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
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        width: 70,
        child: CircularProgressIndicator(
          strokeWidth: 10,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
