import 'package:flutter/material.dart';

class FancyCard extends StatelessWidget {
  const FancyCard(
      {super.key,
      required this.image,
      required this.title,
      required this.date,
      required this.function});

  final Image image;
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
