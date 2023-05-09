import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:y13_gui_project/Add_Popup/image_display.dart';

class AddPopup extends StatefulWidget {
  @override
  _AddPopupState createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  final formKey = GlobalKey<FormState>();
  File? file;
  String? imageName;
  String? itemName;

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        imageName = result.files.single.name;
      });
      return imageName;
    }

    return null;
  }

  String? imageValidator(String? value) {
    if (file == null) {
      return 'Please choose an image';
    }
    return null;
  }

  Future<void> showAddPopup(BuildContext context) async {
    file = null;
    imageName = null;
    itemName = null;
    bool isSubmited = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: Form(
              key: formKey,
              child: SizedBox(
                height: 276,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        itemName = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Item name',
                      ),
                    ),
                    const SizedBox(height: 30),
                    FormField<String>(
                      validator: imageValidator,
                      autovalidateMode: AutovalidateMode.always,
                      builder: (FormFieldState<String> state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Image'),
                                  TextButton(
                                    onPressed: () async {
                                      String? result = await pickFile();
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
                              if (state.errorText != null && isSubmited)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.errorText ?? '',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12.2,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    if (file != null) ImageDisplay(file: file!)
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
                  } else {
                    isSubmited = true;
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    file = null;
    imageName = null;
    itemName = null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddPopup(context),
      child: const Icon(Icons.add),
    );
  }
}
