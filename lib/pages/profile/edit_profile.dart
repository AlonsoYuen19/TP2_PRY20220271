import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ulcernosis/models/users.dart';
import 'package:ulcernosis/services/medic_service.dart';
import 'package:ulcernosis/services/users_service.dart';
import '../../services/nurse_services.dart';
import '../../utils/helpers/constant_variables.dart';
import '../../utils/widgets/DropDowns/drop_down.dart';
import '../../utils/widgets/text_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Widget title(String title) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: paddingHori, vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w400),
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
  Users? user = Users();
  Future init() async {
    final userProvider = Provider.of<UsersAuthService>(context, listen: false);
    user = await userProvider.getUsersById();
    name = user!.fullName;
    address = user!.address;
    phone = user!.phone;
    dni = user!.dni;
    age = user!.age.toString();
    stateCivil = user!.civilStatus;
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer), // <-- Button color
                  elevation: MaterialStateProperty.all(0), // <-- Splash color
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_outlined,
                    color: Theme.of(context).colorScheme.onTertiary, size: 18)),
          ),
          leadingWidth: 96,
          centerTitle: true,
          toolbarHeight: 98,
          automaticallyImplyLeading: false,
          title: Text(
            "Editar Datos Personales",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
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
                            option: TextInputAction.next,
                          ),
                          title("Telefono	"),
                          GetTextFormField(
                            labelText: phone,
                            placeholder: "",
                            icon: const Icon(Icons.phone),
                            keyboardType: TextInputType.phone,
                            validator: validPhoneEditDoctor(
                                "El número de teléfono debe ser de 9 dígitos"),
                            obscureText: false,
                            controllerr: _phone,
                            isEditProfile: true,
                            option: TextInputAction.next,
                          ),
                          title("Dirección"),
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
                            option: TextInputAction.next,
                          ),
                          SizedBox(height: size.height * 0.01),
                          title("Dni"),
                          GetTextFormField(
                            labelText: dni,
                            placeholder: "",
                            icon: const Icon(Icons.card_membership),
                            keyboardType: TextInputType.number,
                            validator: validDniEditDoctor(
                                "El número del dni debe ser de 8 dígitos"),
                            obscureText: false,
                            controllerr: _dni,
                            isEditProfile: true,
                            option: TextInputAction.next,
                          ),
                          SizedBox(height: size.height * 0.01),
                          title("Edad"),
                          GetTextFormField(
                            labelText: age,
                            placeholder: "",
                            icon: const Icon(Icons.numbers),
                            keyboardType: TextInputType.number,
                            validator: validAge(
                                "La edad debe tener el formato correcto", _age),
                            obscureText: false,
                            controllerr: _age,
                            isEditProfile: true,
                            option: TextInputAction.done,
                          ),
                          SizedBox(height: size.height * 0.01),
                          title("Estado Civil"),
                          DropDownWithSearch(
                            searchController: _stateCivil,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: size.width * 1,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      onPressed: handleButton,
                      child: Text(
                        "Guardar",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future handleButton() async {
    final medicService = MedicAuthServic();
    final nurseService = NurseAuthService();
    final isValidForm = _formKey.currentState!.validate();
    if (isValidForm) {
      print("Nombre Completo: " + capitalizeSentences(_name.text));
      print("Direccion: " + _address.text);
      print("phone: " + _phone.text);
      print("DNI: " + _dni.text);
      print("Edad: " + _age.text);
      print("Estado Civil: " + _stateCivil.text);
      int age = int.parse(_age.text.trim());
      if (user!.role == "ROLE_MEDIC") {
        await medicService.updateMedic(context,
            fullNameMedic: capitalizeSentences(_name.text.trim()),
            stateCivil: _stateCivil.text.trim(),
            address: capitalizeSentences(_address.text.trim()),
            phone: _phone.text.trim(),
            dni: _dni.text.trim(),
            age: age);
      } else {
        await nurseService.updateNurse(context,
            fullName: capitalizeSentences(_name.text.trim()),
            stateCivil: _stateCivil.text.trim(),
            address: capitalizeSentences(_address.text.trim()),
            phone: _phone.text.trim(),
            dni: _dni.text.trim(),
            age: age);
      }

      if (!mounted) {
        return;
      }
    }
  }
}
