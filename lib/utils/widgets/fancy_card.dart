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
    return GestureDetector(
      onTap: function as void Function()?,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.background,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    ExactAssetImage("assets/images/patient-logo.png"),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FancyCardSearchPatient extends StatelessWidget {
  const FancyCardSearchPatient(
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
    return GestureDetector(
      onTap: function as void Function()?,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.background,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    ExactAssetImage("assets/images/patient-logo.png"),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
