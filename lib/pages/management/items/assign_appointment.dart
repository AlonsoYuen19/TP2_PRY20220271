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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          "Crear Cita",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(400, 80))),
        ),
        SafeArea(
            child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.2,
                      ),
                      cardNurse(),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: 56,
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                    ],
                  );
                }))
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
    String fechaFormateada =
        "${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Fecha de cita programada",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fechaFormateada,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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
                              primary:
                                  Theme.of(context).colorScheme.onSecondary,
                              onPrimary: Colors.white,
                              onSurface: Colors.blueAccent,
                              error: Colors.red),
                          textTheme: const TextTheme(
                            bodySmall: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            bodyMedium: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                            bodyLarge: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            displaySmall: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            displayMedium: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                            displayLarge: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                            titleSmall: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            titleMedium: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                            titleLarge: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                            labelSmall: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
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
          const SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Dirección",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
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
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
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
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              switchVariable == false ? direccion! : patient!.address,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
