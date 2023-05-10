import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y13_gui_project/main.dart';

const List<Widget> options = <Widget>[
  Text('In Stock'),
  Text('Issued'),
];

class StockStatusToggle extends StatefulWidget {
  const StockStatusToggle({super.key});

  @override
  State<StockStatusToggle> createState() => _StockStatusToggleState();
}

class _StockStatusToggleState extends State<StockStatusToggle> {
  final List<bool> _selectedOptions = <bool>[true, true];

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return ToggleButtons(
      isSelected: _selectedOptions,
      onPressed: (int index) {
        setState(() {
          if (index == 1) {
            appState.setIsShowingIssued();
          } else {
            appState.setIsShowingReturned();
          }
          _selectedOptions[index] = !_selectedOptions[index];
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      children: options,
    );
  }
}
