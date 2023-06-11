import 'package:flutter/material.dart';
import 'package:ulcernosis/utils/widgets/text_form_field.dart';

class SearchableTitle extends StatelessWidget {
  const SearchableTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetTextFormField(
          icon: Icon(Icons.search),
          placeholder: "Buscar...",
          labelText: 'Buscar...',
          keyboardType: TextInputType.name,
          validator: null),
    );
  }
}
