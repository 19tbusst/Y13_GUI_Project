import 'package:flutter/material.dart';

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
    return ToggleButtons(
      isSelected: _selectedOptions,
      onPressed: (int index) {
        setState(() {
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
