import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';

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
  final TextInputAction? option;
  final Function(String)? onSubmit;
  final void Function()? onChanged;
  final GlobalKey<FormState>? keyy;
  final bool? enabled;
  final Widget? prefixIcon;
  const GetTextFormField(
      {super.key,
      required this.labelText,
      required this.placeholder,
      this.controllerr,
      required this.icon,
      required this.keyboardType,
      required this.validator,
      this.obscureText = false,
      this.isRegisterPassword = true,
      this.isEditProfile = false,
      this.maxLength = 30,
      this.option,
      this.onSubmit,
      this.keyy,
      this.enabled,
      this.prefixIcon,
      this.onChanged});

  @override
  State<GetTextFormField> createState() => _GetTextFormFieldState();
}

class _GetTextFormFieldState extends State<GetTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).colorScheme.onSurface;
    final size = MediaQuery.of(context).size;
    return /*RawKeyboardListener(
      focusNode: FocusNode(onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          _focusNode.nextFocus();
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      }),
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.enter)) {
          _focusNode.requestFocus();
        }
      },
      child: */
        widget.obscureText
            ? Container(
                padding: widget.isRegisterPassword
                    ? null
                    : const EdgeInsets.symmetric(horizontal: 20),
                child: FancyPasswordField(
                  enabled: widget.enabled ?? true,
                  maxLength: 20,
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
                      return Text(
                        "Ingrese una contraseña",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                      );
                    }
                    return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: rules
                            .map(
                              (rule) => rule.validate(value)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          size: 24,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          rule.name,
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.close,
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          rule.name,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                            )
                            .toList());
                  },
                  obscuringCharacter: "*",
                  onFieldSubmitted: widget.onSubmit,
                  onEditingComplete: widget.onChanged,
                  textInputAction: widget.option,
                  validator: widget.validator,
                  keyboardType: widget.keyboardType,
                  cursorColor: _color,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none),
                  controller: widget.controllerr,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1),
                    ),
                    counterText: widget.isRegisterPassword ? null : "",
                    counterStyle: TextStyle(fontWeight: FontWeight.w600),
                    helperText: null,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                    errorStyle: TextStyle(
                      height: 0,
                      color: Theme.of(context).colorScheme.error,
                      fontSize: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12)
                          .fontSize,
                    ),
                    errorMaxLines: 2,
                    suffixIconColor: _color,
                    labelText: widget.labelText,
                    hintText: widget.placeholder,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: _color, width: 1.2)),
                  ),
                ),
              )
            : Container(
                padding: widget.isRegisterPassword
                    ? null
                    : const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  enabled: widget.enabled ?? true,
                  textCapitalization: TextCapitalization.sentences,
                  key: widget.key,
                  maxLength: widget.maxLength,
                  onFieldSubmitted: widget.onSubmit,
                  textInputAction: widget.option,
                  autofocus: false,
                  validator: widget.validator,
                  keyboardType: widget.keyboardType,
                  cursorColor: _color,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      decorationThickness: 0),
                  controller: widget.controllerr,
                  decoration: InputDecoration(
                    prefixIcon: widget.prefixIcon,
                    counterText: "",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        backgroundColor: Colors.transparent,
                        color: widget.enabled == null
                            ? Theme.of(context).colorScheme.onSurface
                            : Color.fromRGBO(169, 168, 170, 1),
                        fontWeight: FontWeight.w400),
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12)
                          .fontSize,
                    ),
                    errorMaxLines: 2,
                    labelText: widget.labelText,
                    hintText: widget.placeholder,
                    /*hintStyle:
                        TextStyle(color: Color.fromRGBO(11, 168, 180, 1)),*/
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: _color, width: 1.2)),
                  ),
                ),
              );
    //),
    //);
  }
}
