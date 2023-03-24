import 'dart:typed_data';

import 'package:flutter/material.dart';

class FancyCard extends StatelessWidget {
  const FancyCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.function, //required this.image2,
  });

  final Image image;
  //final Uint8List image2;
  final String title;
  final String date;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Wrap(children: [
          SizedBox(
            width: 250,
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    /*image2.isEmpty 
                        ? Container(
                            height: 70,
                            margin: const EdgeInsets.only(
                              top: 24.0,
                              bottom: 16.0,
                            ),
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/patient-logo.png"),
                                  fit: BoxFit.fitHeight),
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(
                                image2,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover),
                          ),*/
                    SizedBox(
                      height: 70,
                      child: image,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            date,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: function as void Function()?,
                        child: const Text(
                          "Saber más",
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}

class FancyCardSearchPatient extends StatelessWidget {
  const FancyCardSearchPatient(
      {super.key,
      required this.image,
      required this.title,
      required this.date,
      required this.date2,
      required this.function});

  final Image image;
  final String title;
  final String date;
  final String date2;
  final Function function;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.8,
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: image,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          date2,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: function as void Function()?,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Saber más",
                          style: TextStyle(fontSize: 24),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
