// Flutter packages
import 'package:flutter/material.dart';

// Dart packages
import 'dart:async';
import 'dart:convert';

// Pub packages
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

// Local files
import 'package:y13_gui_project/main.dart';
import 'stock_status_toggle.dart';
import 'sorting_dropdown.dart';
import 'item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> _items = <Item>[];

  // reads items from the database
  Future<dynamic> read() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('items');

    // creates a completer to return the data
    Completer<dynamic> completer = Completer<dynamic>();
    late StreamSubscription<DatabaseEvent> subscription;

    // listens for changes in the database
    subscription = ref.onValue.listen((event) {
      final data = jsonEncode(event.snapshot.value);
      subscription.cancel();

      completer.complete(data);
    });
    
    return completer.future;
  }

  // sorts items by name
  void sortName(bool invert) {
    _items.sort((a, b) => a.name.compareTo(b.name));

    // if invert is true, reverse the list
    if (invert) {
      _items = _items.reversed.toList();
    }
  }

  // sorts items by date
  void sortDate(bool invert) {
    _items.sort((a, b) => a.date.compareTo(b.date));

    // if invert is true, reverse the list
    if (invert) {
      _items = _items.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    // reads items from the database
    read().then((data) {

      // if data is not null, decode it and set the items list
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
                      dueDate: DateTime.parse(e['dueDate'] as String),
                    ))
                .toList();
          });
        } else {
          // if jsonData is not a Map, set the items list to an empty list
          setState(() {
            _items = <Item>[];
          });
        }
      } else {
        // if data is null, set the items list to an empty list
        setState(() {
          _items = <Item>[];
        });
      }
    });

    // sort items based on sorting mode
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

    // return the home page
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // sorting dropdown and stock status toggle
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
            // maps items to ItemCards
            children: _items.map((item) {
              // hides items that are toggled off
              if ((item.isIssued && appState.isShowingIssued) ||
                  (!item.isIssued && appState.isShowingReturned)) {
                // pass the item to the ItemCard
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
