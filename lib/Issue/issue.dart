import 'package:flutter/material.dart';
import 'sorting_dropdown.dart';
import 'item_card.dart';
import 'stock_status_toggle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:convert';

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
  List<Item> _items = <Item>[];

  @override
  Widget build(BuildContext context) {
    Item item1 = Item(
      id: 2,
      name: 'Item 3',
      isIssued: false,
      date: DateTime.now(),
      image:
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
    );

    Future<dynamic> read() async {
      DatabaseReference ref = FirebaseDatabase.instance.ref('items');

      Completer<dynamic> completer = Completer<dynamic>();
      late StreamSubscription<DatabaseEvent> subscription;

      subscription = ref.onValue.listen((event) {
        final data = jsonEncode(event.snapshot.value);
        subscription.cancel();

        completer.complete(data);
      });

      return completer.future;
    }

    void write(Item item) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref("items/");

      await ref.child(item.id.toString()).set({
        'name': item.name,
        'isIssued': item.isIssued,
        'date': item.date.toString(),
        'image': item.image,
        'id': item.id,
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
              TextButton(onPressed: () => write(item1), child: Text('write')),
              TextButton(
                  onPressed: () async {
                    read().then((data) {
                      if (data != null) {
                        final List<dynamic> jsonData = jsonDecode(data);
                        setState(() {
                          _items = jsonData
                              .map((e) => Item(
                                    id: e['id'] as int,
                                    name: e['name'] as String,
                                    isIssued: e['isIssued'] as bool,
                                    date: DateTime.parse(e['date'] as String),
                                    image: e['image'] as String,
                                  ))
                              .toList();
                        });
                      } else {
                        _items = <Item>[];
                      }
                    });
                  },
                  child: Text('read')),
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
            children: _items.map((item) {
              return ItemCard(item: item);
            }).toList(),
          ),
        )
      ],
    );
  }
}
