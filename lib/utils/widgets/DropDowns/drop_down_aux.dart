import 'package:flutter/material.dart';

class DropDownWithAuxiliar extends StatefulWidget {
  final TextEditingController searchController;
  final bool isEditProfile;
  const DropDownWithAuxiliar({
    Key? key,
    required this.searchController,
    this.isEditProfile = false,
  }) : super(key: key);

  @override
  State<DropDownWithAuxiliar> createState() => _DropDownWithAuxiliarState();
}

class _DropDownWithAuxiliarState extends State<DropDownWithAuxiliar> {
  @override
  void initState() {
    widget.searchController.text = "Si";
    super.initState();
  }

  Color newColor = Colors.lightBlue;
  Color newColor2 = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.onBackground,
            border: Border.all(
                width: 5,
                //color: newColor,
                color: newColor2),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: DropdownButton<String>(
                dropdownColor: Theme.of(context).colorScheme.onBackground,
                focusColor: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                icon: const Icon(Icons.person),
                iconSize: 30,
                value: widget.searchController.text,
                items: <String>[
                  'Si',
                  'No'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.searchController.text = newValue!;
                    newColor = Colors.white;
                    newColor2 = Colors.white;
                  });
                  print(widget.searchController.text);
                },
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 19,
                ),
                isExpanded: true,
                iconEnabledColor: Colors.white,
              )),
        ),
      ],
    );
  }
}
