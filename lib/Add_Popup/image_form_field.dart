// Flutter packages
import 'package:flutter/material.dart';
import 'dart:io';

// Pub packages
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

// Local files
import 'package:y13_gui_project/main.dart';

// picks file from device
Future<String?> pickFile(context) async {
  AppState appState = Provider.of<AppState>(context, listen: false);

  // Pick file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  // If file isn't null, set it to appState.file
  if (result != null) {
    File file = File(result.files.single.path!);

    appState.setFile(file);
  }

  return null;
}

imageFormField(imageValidator, pickFile, isSubmitted, setState, context) {
  return FormField<String>(
    validator: imageValidator,
    autovalidateMode: AutovalidateMode.always,
    builder: (FormFieldState<String> state) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Image'),
                TextButton(
                  onPressed: () async {
                    // Picks file
                    final String? result = await pickFile(context);
                    if (result != null) {
                      setState(() {
                        state.reset();
                      });
                    }
                  },
                  child: const Text('Choose image'),
                ),
              ],
            ),
            // Displays error text
            if (state.errorText != null && isSubmitted)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    state.errorText ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12.2,
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    },
  );
}
