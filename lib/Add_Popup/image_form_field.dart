import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y13_gui_project/main.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<String?> pickFile(context) async {
  AppState appState = Provider.of<AppState>(context, listen: false);

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    String imageName = result.files.single.name;

    appState.setFile(file);
    appState.setImageName(imageName);
  }

  return null;
}

imageFormField(imageValidator, pickFile, isSubmitted, setState, context) {
  AppState appState = Provider.of<AppState>(context, listen: false);

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
