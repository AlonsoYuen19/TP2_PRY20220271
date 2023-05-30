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
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
            border: Border.all(
                width: 1.2,
                //color: newColor,
                color: Color.fromRGBO(14, 26, 48, 1)),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                underline: const SizedBox(),
                focusColor: Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(14, 26, 48, 1),
                ),
                iconSize: 30,
                value: widget.searchController.text,
                items: <String>['Si', 'No']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontSize: 16, color: Color.fromRGBO(14, 26, 48, 1)),
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
                  color: Colors.white,
                  fontSize: 16,
                ),
                isExpanded: true,
                iconEnabledColor: Colors.white,
              )),
        ),
      ],
    );
  }
}
