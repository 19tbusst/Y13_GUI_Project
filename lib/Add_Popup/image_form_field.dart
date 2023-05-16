import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y13_gui_project/main.dart';

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
                    final String? result = await pickFile();
                    appState.setResult(result);
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
