import 'package:flutter/material.dart';
import 'sorting_dropdown.dart';
import 'item_card.dart';
import 'stock_status_toggle.dart';
import 'package:firebase_database/firebase_database.dart';

class Item {
  String name;
  bool isIssued;
  DateTime date;
  String image;
  int id;

  Item({
    required this.id,
    required this.name,
    required this.isIssued,
    required this.date,
    required this.image,
  });
}

class Issue extends StatefulWidget {
  const Issue({super.key});

  @override
  State<Issue> createState() => _IssueState();
}

class _IssueState extends State<Issue> {
  @override
  Widget build(BuildContext context) {
    Item item1 = Item(
      id: 0,
      name: 'Item 1',
      isIssued: true,
      date: DateTime.now(),
      image:
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    );

    void read(int id) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('items/$id');
      ref.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        print(data);
      });
    }

    void write(Item item) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref("items/");

      await ref.child(item.id.toString()).set({
        'name': item.name,
        'isIssued': item.isIssued,
        'date': item.date.toString(),
        'image': item.image,
      });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SortingDropdown(),
              const StockStatusToggle(),
              TextButton(onPressed: () => read(0), child: Text('read')),
              TextButton(onPressed: () => write(item1), child: Text('write')),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 120,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: ListView(
            shrinkWrap: false,
            children: <ItemCard>[
              ItemCard(item: item1),
              ItemCard(item: item1),
              ItemCard(item: item1),
              ItemCard(item: item1),
              ItemCard(item: item1),
              ItemCard(item: item1),
              ItemCard(item: item1),
            ],
          ),
        )
      ],
    );
  }
}
