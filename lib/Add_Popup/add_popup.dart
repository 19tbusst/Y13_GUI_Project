import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:y13_gui_project/HomePage/home_page.dart';
import 'package:y13_gui_project/Add_Popup/image_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPopup extends StatefulWidget {
  const AddPopup({super.key});

  @override
  _AddPopupState createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  final formKey = GlobalKey<FormState>();
  File? file;
  String? imageName;
  String? itemName;
  bool isSubmitted = false;

  Future write(Item item) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("items/");

    await ref.child(item.id.toString()).set({
      'name': item.name,
      'isIssued': item.isIssued,
      'date': item.date.toString(),
      'image': item.image,
      'id': item.id,
    });
  }

  Future<String> upload(String uuid, File file) async {
    final storage = FirebaseStorage.instance;
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images");
    final imageRef = imagesRef.child(uuid);

    await imageRef.putFile(file);

    String url = '';
    await imageRef.getDownloadURL().then((value) => url = value);
    return url;
  }

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

  String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<void> showAddPopup(BuildContext context) async {
    file = null;
    imageName = null;
    itemName = null;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: Form(
              key: formKey,
              child: SizedBox(
                height: 298,
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
                              if (state.errorText != null && isSubmitted)
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
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added')),
                    );

                    Navigator.of(context).pop();

                    String url = '';
                    url = await upload(generateUniqueId(), file!);

                    Item item = Item(
                      id: generateUniqueId(),
                      name: itemName!,
                      image: url,
                      date: DateTime.now(),
                      isIssued: false,
                    );

                    await write(item);
                  } else {
                    setState(() {
                      isSubmitted = true;
                    });
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
