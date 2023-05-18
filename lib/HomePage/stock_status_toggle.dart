// Flutter package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// local files
import 'package:y13_gui_project/main.dart';

// toggle button options
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
  // sets the initial state of the toggle buttons
  final List<bool> _selectedOptions = <bool>[true, true];

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return ToggleButtons(
      isSelected: _selectedOptions,
      // changes the state of the toggle buttons
      onPressed: (int index) {
        setState(() {
          if (index == 1) {
            setState(() {
              appState.isShowingIssued = !appState.isShowingIssued;
            });
          } else {
            setState(() {
              appState.isShowingReturned = !appState.isShowingReturned;
            });
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
