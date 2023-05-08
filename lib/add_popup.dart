import 'package:flutter/material.dart';

Future addPopup(BuildContext context) {
  final formKey = GlobalKey<FormState>();

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
