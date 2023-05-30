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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: function as void Function()?,
      child: Container(
        width: size.width * 0.85,
        padding: const EdgeInsets.only(bottom: 5, top: 5, left: 25, right: 25),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.background,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      ExactAssetImage("assets/images/patient-logo.png"),
                ),
                SizedBox(width: size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      date,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: function as void Function()?,
      child: Container(
        width: size.width * 0.85,
        //padding: const EdgeInsets.only(bottom: 5, top: 5, left: 25, right: 25),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.background,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      ExactAssetImage("assets/images/patient-logo.png"),
                ),
                SizedBox(width: size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      date,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
