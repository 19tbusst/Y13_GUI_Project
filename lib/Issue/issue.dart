import 'package:flutter/material.dart';
import 'sorting_dropdown.dart';
import 'item_card.dart';
import 'stock_status_toggle.dart';

class Issue extends StatefulWidget {
  const Issue({super.key});

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SortingDropdown(),
              StockStatusToggle(),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 176,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: ListView(
            shrinkWrap: false,
            children: const [
              ItemCard(),
              ItemCard(),
              ItemCard(),
              ItemCard(),
              ItemCard(),
              ItemCard(),
              ItemCard(),
              ItemCard(),
            ],
          ),
        )
      ],
    );
  }
}
