import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:y13_gui_project/main.dart';

class SortingDropdown extends StatefulWidget {
  const SortingDropdown({super.key});

  @override
  State<SortingDropdown> createState() => _SortingDropdownState();
}

class _SortingDropdownState extends State<SortingDropdown> {
  // dropdown menu entries
  List<DropdownMenuEntry> dropdownEntrys = [
    const DropdownMenuEntry(value: 'name_az', label: 'Name A-Z'),
    const DropdownMenuEntry(value: 'name_za', label: 'Name Z-A'),
    const DropdownMenuEntry(value: 'newest', label: 'Newest'),
    const DropdownMenuEntry(value: 'oldest', label: 'Oldest'),
  ];

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    // changes the dropdown menu entries based on the sorting mode
    return DropdownMenu(
      initialSelection: 'name_az',
      dropdownMenuEntries: dropdownEntrys,
      onSelected: (value) {
        setState(() {
          appState.sortingMode = value;
        });
      },
    );
  }
}
