// Flutter packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Dart packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  // maps items from the database
  Future<List<Item>> mapItems() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final data = await read();

    // if data is null, return an empty list
    if (data == null) {
      return <Item>[];
    }

    final dynamic jsonData = jsonDecode(data);

    // if jsonData is not a Map, return an empty list
    if (jsonData is! Map<String, dynamic>) {
      return <Item>[];
    }

    // if jsonData is a Map, return the list of mapped items
    List<Item> items = jsonData.values
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

    List<String> suggestions = items.map((e) => e.name).toList();
    appState.setSearchSuggestions(suggestions);

    return items;
  }

  // calls mapItems() and updates the items list on future completion
  void updateItems() async {
    List<Item> items = await mapItems();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    // update items
    updateItems();

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

    int offsetHeight = 120;
    if (!kIsWeb) {
      offsetHeight = Platform.isIOS || Platform.isAndroid ? 188 : offsetHeight;
    }

    List<Widget?> usedCards = [];
    bool isEmpty = true;
    usedCards.addAll(_items.map((item) {
      // Only show items that match the search query
      String search = appState.searchQuery.toLowerCase();
      bool isSearched = item.name.toLowerCase().startsWith(search);

      if (!isSearched && appState.searchQuery.isNotEmpty) {
        return Container();
      }

      // hides items that are toggled off
      bool isStockToggle = !item.isIssued && appState.isShowingReturned;
      bool isIssueToggle = item.isIssued && appState.isShowingIssued;

      if (!isIssueToggle && !isStockToggle) {
        // pass the item to the ItemCard
        return null;
      }

      isEmpty = false;
      return ItemCard(item: item);
    }).toList());

    print(isEmpty);

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
            maxHeight: MediaQuery.of(context).size.height - offsetHeight,
            maxWidth: 800,
          ),
          child: ListView(
            shrinkWrap: false,
            // maps items to ItemCards
            children: !isEmpty
                ? usedCards.whereType<Widget>().toList()
                : [
                    const Center(
                      child: Text("No items fit your search criteria"),
                    ),
                  ],
          ),
        )
      ],
    );
  }
}
