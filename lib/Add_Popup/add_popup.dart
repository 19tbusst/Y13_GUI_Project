// Flutter packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Pub packages
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

// local files
import 'package:storio/Add_Popup/image_display.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:storio/Add_Popup/image_form_field.dart';
import 'package:storio/main.dart';

class AddPopup extends StatefulWidget {
  const AddPopup({super.key});

  @override
  _AddPopupState createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  AppState? appState;

  final formKey = GlobalKey<FormState>();
  String? itemName;
  bool isSubmitted = false;

  // Writes item to Firebase
  Future write(Item item) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("items/");

    await ref.child(item.id.toString()).set({
      'name': item.name,
      'isIssued': item.isIssued,
      'date': item.date.toString(),
      'image': item.image,
      'id': item.id,
      'borrowerName': item.borrowerName,
      'borrowerEmail': item.borrowerEmail,
      'dueDate': item.dueDate.toString(),
    });
  }

  // Uploads image to Firebase Storage
  Future<String> upload(String uuid, dynamic file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images");
    final imageRef = imagesRef.child(uuid);

    // Upload image
    if (file is File) await imageRef.putFile(file);
    if (file is Uint8List) await imageRef.putData(file);

    // Get image URL
    String url = '';
    await imageRef.getDownloadURL().then((value) => url = value);
    return url;
  }

  // Generates unique ID for item
  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  // Add item popup
  Future<void> showAddPopup(BuildContext context) async {
    appState?.setFile(null);
    appState?.setFileBytes(null);
    itemName = null;

    isSubmitted = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: SizedBox(
                  height: 312,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextFormField(
                        // validates item name
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
                      // image form field
                      imageFormField(pickFile, isSubmitted, setState, context),
                      const Spacer(),
                      Consumer<AppState>(
                        builder: (BuildContext context, AppState appState,
                            Widget? child) {
                          // displays image
                          if (appState.file != null ||
                              appState.fileBytes != null) {
                            return ImageDisplay();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () async {
                  // validates form
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added')),
                    );

                    Navigator.of(context).pop();

                    String url = '';

                    // generates new item
                    Item item = Item(
                      id: generateUniqueId(),
                      name: itemName!,
                      image: url,
                      date: DateTime.now(),
                      isIssued: false,
                      borrowerName: '',
                      borrowerEmail: '',
                      dueDate: DateTime.now(),
                    );

                    // uploads image
                    if (appState?.file != null) {
                      url = await upload(generateUniqueId(), appState!.file!);
                    }

                    if (appState?.fileBytes != null) {
                      url = await upload(
                          generateUniqueId(), appState!.fileBytes!);
                    }

                    item.image = url;

                    // writes item to Firebase
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

  // resets properties
  @override
  void initState() {
    super.initState();
    appState?.setFile(null);
    itemName = null;
  }

  // Builds floating action button
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context, listen: false);

    return FloatingActionButton(
      onPressed: () => showAddPopup(context),
      child: const Icon(Icons.add),
    );
  }
}
