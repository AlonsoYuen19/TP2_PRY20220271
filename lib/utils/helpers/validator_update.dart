import 'package:flutter/material.dart';

class ValidatorEditDoctor {
  static FormFieldValidator<String> nameValidEdit(String errorMessage) {
    return (value) {
      if (!RegExp(r'^[a-z A-ZáéíóúÁÉÍÓÚüÜ]+$').hasMatch(value!)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> lastNameValidEdit(String errorMessage) {
    return (value) {
      if (!RegExp(r'^[a-z A-ZáéíóúÁÉÍÓÚüÜ]+$').hasMatch(value!)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> ageValidEdit(
      String errorMessage, TextEditingController min) {
    return (value) {
      if (!RegExp(r'^[1-9][0-9]?$').hasMatch(value!)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> phoneValidEdit(String errorMessage) {
    return (value) {
      if (!RegExp(r'^[0-9]+$').hasMatch(value!) || value.length != 9) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> dniValidEdit(String errorMessage) {
    return (value) {
      if (!RegExp(r'^[0-9]+$').hasMatch(value!) || value.length != 8) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }

  static FormFieldValidator<String> addressValidEdit(String errorMessage) {
    return (value) {
      if (value!.isEmpty ||
          !RegExp(r'^[a-zA-Z0-9., áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ-]+$')
              .hasMatch(value)) {
        return errorMessage;
      } else {
        return null;
      }
    };
  }
}
