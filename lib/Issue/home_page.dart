import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y13_gui_project/main.dart';
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
  String id;

  Item({
    required this.id,
    required this.name,
    required this.isIssued,
    required this.date,
    required this.image,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> _items = <Item>[];

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

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    read().then((data) {
      if (data != null) {
        final Map<String, dynamic> jsonData = jsonDecode(data);
        setState(() {
          _items = jsonData.values
              .map((e) => Item(
                    id: e['id'] as String,
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              SortingDropdown(),
              StockStatusToggle(),
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
              if ((item.isIssued && appState.isShowingIssued) ||
                  (!item.isIssued && appState.isShowingReturned)) {
                return ItemCard(item: item);
              } else {
                return Container();
              }
            }).toList(),
          ),
        )
      ],
    );
  }
}
