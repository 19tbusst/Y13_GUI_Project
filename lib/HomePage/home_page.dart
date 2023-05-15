import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:y13_gui_project/main.dart';
import 'stock_status_toggle.dart';
import 'sorting_dropdown.dart';
import 'item_card.dart';

class Item {
  String name;
  bool isIssued;
  DateTime date;
  String image;
  String id;
  String borrowerName;
  String borrowerEmail;

  Item({
    required this.id,
    required this.name,
    required this.isIssued,
    required this.date,
    required this.image,
    required this.borrowerName,
    required this.borrowerEmail,
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

  void sortName(bool invert) {
    _items.sort((a, b) => a.name.compareTo(b.name));
    if (invert) {
      _items = _items.reversed.toList();
    }
  }

  void sortDate(bool invert) {
    _items.sort((a, b) => a.date.compareTo(b.date));
    if (invert) {
      _items = _items.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    read().then((data) {
      if (data != null) {
        final dynamic jsonData = jsonDecode(data);

        if (jsonData is Map<String, dynamic>) {
          setState(() {
            _items = jsonData.values
                .map((e) => Item(
                      id: e['id'] as String,
                      name: e['name'] as String,
                      isIssued: e['isIssued'] as bool,
                      date: DateTime.parse(e['date'] as String),
                      image: e['image'] as String,
                      borrowerName: e['borrowerName'] as String,
                      borrowerEmail: e['borrowerEmail'] as String,
                    ))
                .toList();
          });
        } else {
          setState(() {
            _items = <Item>[];
          });
        }
      } else {
        setState(() {
          _items = <Item>[];
        });
      }
    });

    switch (appState.sortingMode) {
      case 'name_az':
        sortName(false);
        break;
      case 'name_za':
        sortName(true);
        break;
      case 'newest':
        sortDate(true);
        break;
      case 'oldest':
        sortDate(false);
        break;
    }

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
