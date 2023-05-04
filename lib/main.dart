import 'package:flutter/material.dart';
import 'package:y13_gui_project/stock_status_toggle.dart';
import 'package:y13_gui_project/sorting_dropdown.dart';
import 'package:y13_gui_project/item_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Text('Stor.io'),
          actions: const [Placeholder()],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SortingDropdown(),
                StockStatusToggle(),
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 162),
              child: ListView(
                shrinkWrap: false,
                children: const [
                  ItemCard(),
                  ItemCard(),
                  ItemCard(),
                  ItemCard(),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Issue',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restore),
              label: 'Return',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
          ],
        ));
  }
}
