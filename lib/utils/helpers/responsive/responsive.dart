import 'package:flutter/material.dart';

class Responsive {
  late bool _isShortSide;
  
  Responsive(BuildContext context);
  bool get tablet => _isShortSide;

  static Responsive of(BuildContext context) => Responsive(context);
  isShortSide(BuildContext context) =>
      _isShortSide = MediaQuery.of(context).size.shortestSide <= 400;
}
