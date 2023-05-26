import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ulcernosis/models/nurse.dart';
import 'package:ulcernosis/models/patient.dart';
import 'package:ulcernosis/services/patient_service.dart';
import 'package:ulcernosis/services/team_work_service.dart';
import '../../../services/appointment_service.dart';

class AssignItineraryPage extends StatefulWidget {
  final int idNurse;
  final int idPatient;
  const AssignItineraryPage(
      {super.key, required this.idNurse, required this.idPatient});

  @override
  State<AssignItineraryPage> createState() => _AssignItineraryPageState();
}

class _AssignItineraryPageState extends State<AssignItineraryPage> {
  Nurse? nurse = Nurse();
  Patient? patient = Patient();
  final teamWorkService = TeamWorkService();
  final patientService = PatientService();
  final appointmentService = AppointmentService();
  Uint8List avatar = Uint8List(0);
  Uint8List avatar2 = Uint8List(0);
  DateTime? date = DateTime.now().subtract(const Duration(hours: 5));
  late int hour;
  late int minute;
  late TimeOfDay time;
  late int hour2;
  late int minute2;
  late TimeOfDay time2;
  bool switchVariable = false;
  String? direccion = "Centro Médico";
  TextEditingController _controllerIn = TextEditingController();
  TextEditingController _controllerOut = TextEditingController();
  Future init() async {
    nurse = await teamWorkService.getNurseByIdTW(widget.idNurse);
    avatar = (await teamWorkService.getNurseImageTeamWork(widget.idNurse));
    avatar2 =
        (await patientService.getPatientImageFromBackend(widget.idPatient));
    patient =
        await appointmentService.getPatientOnAppointmentById(widget.idPatient);
    setState(() {
      print("El enfermero es: ${nurse!.fullName}");
      print("El paciente tiene como id ${widget.idPatient}");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    hour = DateTime.now().subtract(const Duration(hours: 5)).hour;
    minute = DateTime.now().minute;
    time = TimeOfDay(hour: hour, minute: minute);
    hour2 = DateTime.now().subtract(const Duration(hours: 5)).hour;
    minute2 = DateTime.now().minute;
    time2 = TimeOfDay(hour: hour2, minute: minute2);
    print("El valor del switch es: ${switchVariable.toString()}");
    print("La hora es: ${date.toString().substring(0, 16)}");
    print("La direccion es: $direccion");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String fechaFormateada =
        "${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}";
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(100))),
        ),
        SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(children: [
              Row(
                children: [
                  InkWell(
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                      onTap: () => Navigator.pop(context)),
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  const Flexible(
                    child: Text(
                      "Crear Cita",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.transparent,
                      ));
                    }
                    return Column(
                      children: [
                        cardNurse(),
                        const SizedBox(
                          height: 30,
                        ),
                        /*textFormField(
                              timeOfDayIn: true,
                              labelText: "Hora de entrada",
                              controller: _controllerIn,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            textFormField(
                              timeOfDayIn: false,
                              labelText: "Hora de salida",
                              controller: _controllerOut,
                            ),
                            const SizedBox(
                              height: 30,
                            ),*/
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              print(fechaFormateada);
                              print(widget.idNurse);
                              print(widget.idPatient);
                              if (switchVariable == false) {
                                direccion = "Centro Médico";
                              } else {
                                direccion = patient!.address;
                              }
                              print(direccion);
                              appointmentService.createAppointment(
                                  context,
                                  fechaFormateada,
                                  direccion!,
                                  widget.idNurse,
                                  widget.idPatient);
                            },
                            child: const Text(
                              "Crear Cita",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    );
                  })
            ]),
          ),
        ))
      ]),
    );
  }

  Widget textFormField(
      {bool? timeOfDayIn = true,
      String? labelText,
      TextEditingController? controller}) {
    final hours = timeOfDayIn!
        ? time.hour.toString().padLeft(2, '0')
        : time2.hour.toString().padLeft(2, '0');
    final minutes = timeOfDayIn
        ? time.minute.toString().padLeft(2, '0')
        : time2.minute.toString().padLeft(2, '0');
    final amPm = timeOfDayIn
        ? time.period == DayPeriod.am
            ? 'am'
            : 'pm'
        : time2.period == DayPeriod.am
            ? 'am'
            : 'pm';
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: controller,
        onTap: () {
          print("Tapped");
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "El campo no puede estar vacio";
          }
          return null;
        },
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            Icons.access_time,
            color: Theme.of(context).colorScheme.onSecondary,
            size: 22,
          ),
          hintText: '$hours:$minutes $amPm',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 32,
            ),
            onPressed: () async {
              TimeOfDay? newTime = await showTimePicker(
                helpText: labelText,
                cancelText: "Cancelar",
                confirmText: "Aceptar",
                context: context,
                initialEntryMode: TimePickerEntryMode.dialOnly,
                initialTime: timeOfDayIn ? time : time2,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10)),
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) =>
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (newTime != null) {
                if (timeOfDayIn) {
                  time = newTime;
                  String timeAux =
                      '${newTime.hour}:${newTime.minute} ${newTime.period == DayPeriod.am ? 'am' : 'pm'}';
                  _controllerIn.text = timeAux;
                } else {
                  time2 = newTime;
                  String timeAux2 =
                      '${newTime.hour}:${newTime.minute} ${newTime.period == DayPeriod.am ? 'am' : 'pm'}';
                  _controllerOut.text = timeAux2;
                }

                setState(() {});
                print("$labelText: " + newTime.toString());
              }
            },
          ),
          labelText: labelText,
          labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold),
          fillColor: Colors.red,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSecondary, width: 4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onSecondary),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget cardNurse() {
    final size = MediaQuery.of(context).size;
    int cantNombreEnfermero = nurse!.fullName.split(" ").length;
    int cantNombrePaciente = patient!.fullName.split(" ").length;
    String fechaFormateada =
        "${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}";
    return Card(
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enfermero",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    avatar.isEmpty
                        ? Container(
                            height: size.width * 0.2,
                            width: size.width * 0.2,
                            //clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/enfermero-logo.png"),
                                  fit: BoxFit.fitHeight),
                              color: Theme.of(context).colorScheme.onSecondary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(avatar,
                                height: size.width * 0.2,
                                width: size.width * 0.2,
                                fit: BoxFit.cover),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        cantNombreEnfermero < 2
                            ? nurse!.fullName
                            : '${nurse!.fullName.split(' ')[0]} ${nurse!.fullName.split(' ')[1]}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Paciente",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    avatar2.isEmpty
                        ? Container(
                            height: size.width * 0.2,
                            width: size.width * 0.2,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/patient-logo.png"),
                                  fit: BoxFit.fitHeight),
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(avatar2,
                                height: size.width * 0.2,
                                width: size.width * 0.2,
                                fit: BoxFit.cover),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        cantNombrePaciente < 2
                            ? patient!.fullName
                            : '${patient!.fullName.split(' ')[0]} ${patient!.fullName.split(' ')[1]}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fecha de cita programada",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fechaFormateada,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          confirmText: "Confirmar",
                          cancelText: "Cancelar",
                          initialDate:
                              DateTime.now().subtract(const Duration(hours: 5)),
                          firstDate:
                              DateTime.now().subtract(const Duration(hours: 5)),
                          lastDate: DateTime(2032, 12, 31),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          helpText: "Seleccione una fecha",
                          locale: const Locale("es"),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.blueAccent,
                                    error: Colors.red),
                                textTheme: const TextTheme(
                                  bodySmall: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  bodyMedium: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  bodyLarge: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  displaySmall: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  displayMedium: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  displayLarge: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  titleSmall: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  titleMedium: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  titleLarge: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                  labelSmall: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      elevation: 10 // button text color
                                      ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            date = value;
                          });
                        });
                      },
                      child: Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Dirección",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              nurse!.isAuxiliar == true
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "¿Atenderá en la dirección del paciente?",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Switch(
                            value: switchVariable,
                            onChanged: (value) {
                              setState(() {
                                switchVariable = value;
                              });
                              print(
                                  "El valor del switch es: ${switchVariable.toString()}");
                            },
                            activeTrackColor:
                                Theme.of(context).colorScheme.onSecondary,
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    switchVariable == false ? direccion! : patient!.address,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
