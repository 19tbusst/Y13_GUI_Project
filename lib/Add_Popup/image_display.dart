// Flutter imports
import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplay extends StatelessWidget {
  ImageDisplay({super.key, required this.file});

  File file;

  @override
  Widget build(BuildContext context) {
    // Displays image
    return Center(
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(file),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
