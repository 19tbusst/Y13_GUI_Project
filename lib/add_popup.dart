import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future addPopup(BuildContext context) {
  final formKey = GlobalKey<FormState>();

  File file = File('');

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Item'),
        content: Form(
          key: formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Item name',
                  ),
                ),
                kIsWeb ? Image.network(file.path) : Image.file(file),
                TextButton(
                  onPressed: () {
                    pickFile();
                  },
                  child: const Text('Select Image'),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item added')),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
