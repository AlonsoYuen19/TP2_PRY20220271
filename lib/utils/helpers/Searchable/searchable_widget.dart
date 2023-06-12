import 'package:flutter/material.dart';
import 'package:ulcernosis/utils/widgets/text_form_field.dart';

class SearchableTitle extends StatelessWidget {
  final void Function()? onChanged;
  final String? title;
  const SearchableTitle({super.key, this.onChanged, this.title = "Buscar..."});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: Theme.of(context).colorScheme.background, width: 1.5)),
        child: GetTextFormField(
            icon: Icon(Icons.search),
            prefixIcon: Icon(Icons.search),
            enabled: false,
            placeholder: "Buscar...",
            labelText: title!,
            keyboardType: TextInputType.name,
            validator: null),
      ),
    );
  }
}
