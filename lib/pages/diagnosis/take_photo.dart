import 'package:flutter/material.dart';

class TakePhotoDiagnosis extends StatefulWidget {
  const TakePhotoDiagnosis({super.key});

  @override
  State<TakePhotoDiagnosis> createState() => _TakePhotoDiagnosisState();
}

class _TakePhotoDiagnosisState extends State<TakePhotoDiagnosis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(100))),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Flexible(
                        child: Text(
                          'Toma la foto de la herida',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                    
              ],
            ),
          ),
        )
      ]),
    );
  }
}
