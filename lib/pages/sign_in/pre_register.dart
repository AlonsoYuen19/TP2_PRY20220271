import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PreRegisterScreen extends StatefulWidget {
  const PreRegisterScreen({super.key});

  @override
  State<PreRegisterScreen> createState() => _PreRegisterScreenState();
}

class _PreRegisterScreenState extends State<PreRegisterScreen> {
  int indexPage = 0;
  List<String> imagesLogo = [
    'assets/images/doctor-logo.png',
    'assets/images/enfermero-logo.png'
  ];
  final textIndex = [
    'Registro de Médico',
    'Registro de Enfermero',
  ];
  final carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
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
            "Crear Cuenta",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        body: SafeArea(
          child: Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: size.width * 1,
                child: Text(
                  "Selecciona tu tipo de usuario",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'register');
              },
              child: Container(
                width: size.width * 1,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(237, 240, 255, 1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Color.fromRGBO(210, 217, 254, 1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svgImages/medico_logo1.svg",
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Soy médico",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(35, 35, 35, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'registerNurse');
              },
              child: Container(
                width: size.width * 1,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 236, 238, 1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Color.fromRGBO(255, 217, 221, 1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svgImages/enfermero_logo1.svg",
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Soy enfermero",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(35, 35, 35, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /*SizedBox(
                height: size.shortestSide > 500
                    ? size.height * 0.1
                    : size.height * 0.03),
            Column(children: [
              CarouselSlider.builder(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        indexPage = index;
                      });
                    },
                    initialPage: 0,
                    pageSnapping: false,
                    enableInfiniteScroll: false,
                    height: 360,
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  ),
                  itemCount: imagesLogo.length,
                  itemBuilder: (context, i, realIndex) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.55,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 8,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 5,
                                    blurRadius: 6,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(imagesLogo[i]),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (i == 0) {
                                      Navigator.pushNamed(context, 'register');
                                    } else if (i == 1) {
                                      Navigator.pushNamed(
                                          context, 'registerNurse');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      textIndex[i],
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.white, fontSize: 22),
                                    ),
                                  )),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ]),*/
          ]),
        ),
      ),
    );
  }

  /*Widget buildButtons({bool stretch = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onPressed: previus,
            child: const Icon(
              Icons.arrow_back,
              size: 32,
            ),
          ),
          stretch ? const Spacer() : const SizedBox(width: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onPressed: next,
            child: const Icon(
              Icons.arrow_forward,
              size: 32,
            ),
          )
        ],
      );

  void animateToSlide(int index) => carouselController.animateToPage(index);
  void previus() => carouselController.previousPage(curve: Curves.easeIn);

  void next() => carouselController.nextPage(curve: Curves.easeIn);*/
}
