// Flutter imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:y13_gui_project/main.dart';

class ImageDisplay extends StatelessWidget {
  ImageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of(context, listen: false);

    // Displays image
    return Center(
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: kIsWeb
                ? MemoryImage(appState.fileBytes!)
                : FileImage(appState.file!) as ImageProvider<Object>,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
