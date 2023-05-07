import 'package:flutter/material.dart';
import 'package:y13_gui_project/Issue/issue.dart';
import 'package:y13_gui_project/Add/add.dart';
import 'package:y13_gui_project/Return/return.dart';
import 'package:y13_gui_project/search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stor.io',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Issue(),
    Return(),
    Add(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchBar(),
      body: _pages.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
