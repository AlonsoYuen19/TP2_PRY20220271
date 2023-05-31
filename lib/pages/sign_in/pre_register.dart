import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ulcernosis/utils/helpers/constant_variables.dart';

import '../../utils/widgets/background_figure.dart';

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
    return Scaffold(
      body: Stack(children: [
        preRegisterBackgroundFigure(context),
        SingleChildScrollView(
          child: SafeArea(
            child: Column(children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.outline,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 10,
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: size.width * 0.1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: paddingHori, vertical: 20),
                      child: Text(
                        "Selección de Usuario",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
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
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 1000),
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
                                        Navigator.pushNamed(
                                            context, 'register');
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
                                                color: Colors.white,
                                                fontSize: 22),
                                      ),
                                    )),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                SizedBox(height: size.height * 0.03),
                AnimatedSmoothIndicator(
                  activeIndex: indexPage,
                  count: imagesLogo.length,
                  onDotClicked: animateToSlide,
                  duration: const Duration(milliseconds: 500),
                  effect: SlideEffect(
                    dotWidth: 30,
                    dotHeight: 30,
                    dotColor: Colors.grey,
                    activeDotColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                buildButtons(stretch: false),
              ]),
            ]),
          ),
        )
      ]),
    );
  }

  Widget buildButtons({bool stretch = false}) => Row(
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

  void next() => carouselController.nextPage(curve: Curves.easeIn);
}
