import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/pages/profile/profile.dart';
import 'package:ulcernosis/services/user_auth_service.dart';

import '../../models/doctor.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/background_figure.dart';
import '../../utils/widgets/drop_down.dart';
import '../../utils/widgets/text_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingHori, vertical: 5),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.lightBlue),
      ),
    );
  }

  String name = "";
  String address = "";
  String phone = "";
  String dni = "";
  String age = "";
  String stateCivil = "";
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _dni = TextEditingController();
  final _age = TextEditingController();
  final _stateCivil = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Doctor? doctorUser = Doctor();
  Future init() async {
    final doctorProvider = Provider.of<UserServiceAuth>(context, listen: false);
    var userId =
        await doctorProvider.getAuthenticateId(prefs.email, prefs.password);
    doctorUser = await doctorProvider.getDoctorById(userId.toString());
    name = doctorUser!.fullNameDoctor;
    address = doctorUser!.address;
    phone = doctorUser!.phone;
    dni = doctorUser!.dni;
    age = doctorUser!.age;
    stateCivil = doctorUser!.stateCivil;
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    _dni.dispose();
    _age.dispose();
    _stateCivil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final doctorProvider = Provider.of<UserServiceAuth>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(children: [
            backgroundFigure(context, x: 400, y: 150, height: 0.15),
            Column(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: paddingHori),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Text(
                            "Editar Perfil",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        title("Nombre Completo"),
                        GetTextFormField(
                          labelText: name,
                          placeholder: "",
                          icon: const Icon(Icons.person_add_alt_1_sharp),
                          keyboardType: TextInputType.name,
                          validator: validNameEditDoctor(
                              "Escriba el nombre con el formato correcto"),
                          controllerr: _name,
                          obscureText: false,
                          isEditProfile: true,
                        ),
                        title("Telefono	"),
                        GetTextFormField(
                            labelText: phone,
                            placeholder: "",
                            icon: const Icon(Icons.phone),
                            keyboardType: TextInputType.phone,
                            validator: validPhoneEditDoctor(
                                "El n??mero de tel??fono debe ser de 9 d??gitos"),
                            obscureText: false,
                            controllerr: _phone,
                            isEditProfile: true),
                        title("Direcci??n"),
                        GetTextFormField(
                          labelText: address,
                          placeholder: "",
                          icon: const Icon(Icons.house),
                          keyboardType: TextInputType.streetAddress,
                          validator: validAddressEditDoctor(
                              "Escriba el correo con el formato correcto"),
                          obscureText: false,
                          controllerr: _address,
                          isEditProfile: true,
                        ),
                        SizedBox(height: size.height * 0.01),
                        title("Dni"),
                        GetTextFormField(
                          labelText: dni,
                          placeholder: "",
                          icon: const Icon(Icons.card_membership),
                          keyboardType: TextInputType.number,
                          validator: validDniEditDoctor(
                              "El n??mero del dni debe ser de 8 d??gitos"),
                          obscureText: false,
                          controllerr: _dni,
                          isEditProfile: true,
                        ),
                        SizedBox(height: size.height * 0.01),
                        title("Edad"),
                        GetTextFormField(
                          labelText: age,
                          placeholder: "",
                          icon: const Icon(Icons.numbers),
                          keyboardType: TextInputType.number,
                          validator: validAgeEditDoctor(
                              "La edad debe tener el formato correcto", _age),
                          obscureText: false,
                          controllerr: _age,
                          isEditProfile: true,
                        ),
                        SizedBox(height: size.height * 0.01),
                        title("Estado Civil"),
                        DropDownWithSearch(
                          searchController: _stateCivil,
                        ),
                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: size.width * 0.35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, elevation: 0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Retroceder",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () async {
                          final isValidForm = _formKey.currentState!.validate();
                          if (isValidForm) {
                            print("Nombre Completo: " + _name.text);
                            print("Direccion: " + _address.text);
                            print("phone: " + _phone.text);
                            print("DNI: " + _dni.text);
                            print("Edad: " + _age.text);
                            print("Estado Civil: " + _stateCivil.text);
                            var userId = await doctorProvider.getAuthenticateId(
                                prefs.email, prefs.password);
                            /*await doctorProvider.updateDoctor(
                              userId.toString(),
                              Doctor(
                                  fullNameDoctor: _name.text.trim(),
                                  address: _address.text.trim(),
                                  phone: _phone.text.trim(),
                                  dni: _dni.text.trim(),
                                  age: _age.text.trim(),
                                  stateCivil: _stateCivil.text.trim()));*/
                            await doctorProvider.updateDoctorTest(
                                userId.toString(),
                                fullNameDoctor: _name.text.trim(),
                                address: _address.text.trim(),
                                phone: _phone.text.trim(),
                                dni: _dni.text.trim(),
                                age: _age.text.trim(),
                                stateCivil: _stateCivil.text.trim());
                            if (!mounted) {
                              return;
                            }

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: Text(
                          "Guardar",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
