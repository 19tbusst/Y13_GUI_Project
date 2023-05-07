import 'package:flutter/material.dart';

class SortingDropdown extends StatefulWidget {
  const SortingDropdown({super.key});

  @override
  State<SortingDropdown> createState() => _SortingDropdownState();
}

class _SortingDropdownState extends State<SortingDropdown> {
  List<DropdownMenuEntry> dropdownEntrys = [
    const DropdownMenuEntry(value: 'name_az', label: 'Name A-Z'),
    const DropdownMenuEntry(value: 'name_za', label: 'Name Z-A'),
    const DropdownMenuEntry(value: 'newest', label: 'Newest'),
    const DropdownMenuEntry(value: 'oldest', label: 'Oldest'),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: 'name_az',
      dropdownMenuEntries: dropdownEntrys,
    );
  }
}
