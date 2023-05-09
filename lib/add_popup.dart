import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddPopup extends StatefulWidget {
  @override
  _AddPopupState createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  final formKey = GlobalKey<FormState>();
  File? file;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    }
  }

  Future<void> showAddPopup(BuildContext context) async {
    file = null;

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
                      decoration: const InputDecoration(
                        hintText: 'Item name',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         const Text('Image'),
                          TextButton(
                            onPressed: () {
                              pickFile().then((value) => setState(() {}));
                            },
                            child: const Text('Choose image'),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 30),
                    if (file != null)
                      Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(file!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    // SizedBox(
                    //   width: 100,
                    //   height: 100,
                    //   child: Image.file(
                    //     file!,
                    //     height: MediaQuery.of(context).size.width / 5,
                    //     width: MediaQuery.of(context).size.width / 5,
                    //   ),
                    // ),
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
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    file = null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddPopup(context),
      child: const Icon(Icons.add),
    );
  }
}
