import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

class GetTextFormField extends StatefulWidget {
  final String labelText;
  final String placeholder;
  final TextEditingController? controllerr;
  final Icon? icon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool isRegisterPassword;
  final bool isEditProfile;
  final int maxLength;
  const GetTextFormField(
      {super.key,
      required this.labelText,
      required this.placeholder,
      this.controllerr,
      required this.icon,
      required this.keyboardType,
      this.validator,
      this.obscureText = false,
      this.isRegisterPassword = true,
      this.isEditProfile = false,this.maxLength=30});

  @override
  State<GetTextFormField> createState() => _GetTextFormFieldState();
}

class _GetTextFormFieldState extends State<GetTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          _focusNode.nextFocus();
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      }),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          _focusNode.nextFocus();
        }
      },
      child: widget.obscureText
          ? Container(
              padding: widget.isRegisterPassword
                  ? null
                  : const EdgeInsets.symmetric(horizontal: paddingHori),
              child: FancyPasswordField(
                maxLength: 20,
                focusNode: _focusNode,
                hasShowHidePassword: true,
                hasStrengthIndicator: false,
                hasValidationRules: widget.isRegisterPassword,
                validationRules: {
                  DigitValidationRule(customText: "Debe tener un número"),
                  UppercaseValidationRule(
                      customText: "Debe tener una mayúscula"),
                  LowercaseValidationRule(
                      customText: "Debe tener una minúscula"),
                  SpecialCharacterValidationRule(
                      customText: "Debe tener un caracter\nespecial"),
                  MinAndMaxCharactersValidationRule(
                      min: 8,
                      max: 20,
                      customText: "Debe tener entre 8 y 20\ncaracteres")
                },
                validationRuleBuilder: (rules, value) {
                  if (value.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Ingrese una contraseña",
                        style: TextStyle(
                          color: Color.fromRGBO(14, 26, 48, 0.8),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: rules
                            .map(
                              (rule) => rule.validate(value)
                                  ? Row(
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          rule.name,
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          rule.name,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                            )
                            .toList()),
                  );
                },
                obscuringCharacter: "*",
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                cursorColor: Theme.of(context).colorScheme.onTertiary,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 20),
                controller: widget.controllerr,
                decoration: InputDecoration(
                  counterText: widget.isRegisterPassword ? null : "",
                  counterStyle: TextStyle(fontWeight: FontWeight.w700),
                  helperText: null,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  errorStyle: TextStyle(
                    height: 0,
                    color: Theme.of(context).colorScheme.error,
                    fontSize: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15)
                        .fontSize,
                  ),
                  errorMaxLines: 2,
                  prefixIconColor: Theme.of(context).colorScheme.onTertiary,
                  suffixIconColor: Theme.of(context).colorScheme.onTertiary,
                  prefixIcon: widget.icon,
                  labelText: widget.labelText,
                  hintText: widget.placeholder,
                  filled: true,
                  fillColor: widget.isRegisterPassword
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context).colorScheme.outline,
                  contentPadding: const EdgeInsets.all(20.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onTertiary,
                        width: 5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 5.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onTertiary,
                          width: 5.0)),
                ),
              ),
            )
          : Container(
              padding: widget.isRegisterPassword
                  ? null
                  : const EdgeInsets.symmetric(horizontal: paddingHori),
              child: TextFormField(
                maxLength: widget.maxLength,
                focusNode: _focusNode,
                autofocus: false,
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                cursorColor: Theme.of(context).colorScheme.onTertiary,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 20),
                controller: widget.controllerr,
                decoration: InputDecoration(
                  counterText: "",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: widget.isRegisterPassword
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context).colorScheme.outline,
                  labelStyle: TextStyle(
                    backgroundColor: Colors.transparent,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  errorStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 16)
                        .fontSize,
                  ),
                  errorMaxLines: 2,
                  prefixIconColor: Theme.of(context).colorScheme.onTertiary,
                  prefixIcon: widget.icon,
                  labelText: widget.labelText,
                  hintText: widget.placeholder,
                  contentPadding:
                      EdgeInsets.all(widget.isEditProfile == false ? 20 : 15),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onTertiary,
                        width: 5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 5.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onTertiary,
                          width: 5.0)),
                ),
              ),
            ),
    );
  }
}
