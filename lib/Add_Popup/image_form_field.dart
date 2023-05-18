// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

// Pub packages
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

// Local files
import 'package:storio/main.dart';

// picks file from device
Future<String?> pickFile(context) async {
  AppState appState = Provider.of<AppState>(context, listen: false);
  appState.file = null;
  appState.fileBytes = null;

  // Pick file differently depending on the platform
  if (kIsWeb) {
    // Handle file picking on web
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowCompression: true,
      allowMultiple: false,
    );

    if (result != null) {
      Uint8List fileBytes = result.files.single.bytes!;
      if (result.files.single.extension == 'jpg' ||
          result.files.single.extension == 'jpeg' ||
          result.files.single.extension == 'png' ||
          result.files.single.extension == 'webp') {
        appState.setFileBytes(fileBytes);
      } else {
        appState.setFileBytes(null);
      }
    }
  } else {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      if (result.files.single.extension == 'jpg' ||
          result.files.single.extension == 'jpeg' ||
          result.files.single.extension == 'png' ||
          result.files.single.extension == 'webp') {
        File file = File(result.files.single.path!);
        appState.setFile(file);
      } else {
        appState.setFile(null);
      }
    }
  }

  return null;
}

imageFormField(pickFile, isSubmitted, setState, context) {
  AppState appState = Provider.of<AppState>(context, listen: false);

  // Validates image
  String? imageValidator(String? value) {
    if (appState.file == null && appState.fileBytes == null) {
      return 'Please choose an image';
    }

    if (appState.file != null) {
      if (appState.file!.lengthSync() > 1000000) {
        return 'Image must be less than 1 MB';
      }
    }

    if (appState.fileBytes != null) {
      if (appState.fileBytes!.length > 1000000) {
        return 'Image must be less than 1 MB';
      }
    }

    return null;
  }

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
