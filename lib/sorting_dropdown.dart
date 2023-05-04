import 'package:flutter/material.dart';

class SortingDropdown extends StatefulWidget {
  const SortingDropdown({super.key});

  @override
  State<SortingDropdown> createState() => _SortingDropdownState();
}

class _SortingDropdownState extends State<SortingDropdown> {
  List<DropdownMenuEntry> dropdownEntrys = [];

  @override
  Widget build(BuildContext context) {
    dropdownEntrys.add(const DropdownMenuEntry(value: 'test', label: 'test'));

    return DropdownMenu(
      initialSelection: 'test',
      dropdownMenuEntries: dropdownEntrys,
    );
  }
}
