import 'dart:typed_data';

import 'package:flutter/material.dart';

class PreviewImagePage extends StatelessWidget {
  final Uint8List avatar;
  final String? tag;
  const PreviewImagePage({super.key, required this.avatar, required this.tag});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.zero,
            constrained: true,
            maxScale: 2.5,
            minScale: 0.8,
            panEnabled: true,
            scaleEnabled: true,
            child: Hero(
              tag: tag!,
              child: Image.memory(
                  filterQuality: FilterQuality.high,
                  avatar,
                  height: size.width * 1,
                  width: size.width * 1,
                  fit: BoxFit.fill),
            ),
          ),
        ));
  }
}
