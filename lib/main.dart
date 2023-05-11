import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:y13_gui_project/Issue/home_page.dart';
import 'package:y13_gui_project/Add/add.dart';
import 'package:y13_gui_project/Return/return.dart';
import 'package:y13_gui_project/Add_Popup/add_popup.dart';
import 'package:y13_gui_project/search_bar.dart';

class AppState extends ChangeNotifier {
  bool isShowingIssued = true;
  bool isShowingReturned = true;

  String sortingMode = 'name_az';

  void setIsShowingIssued() {
    isShowingIssued = !isShowingIssued;
    notifyListeners();
  }

  void setIsShowingReturned() {
    isShowingReturned = !isShowingReturned;
    notifyListeners();
  }

  void setSortingMode(String mode) {
    sortingMode = mode;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
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
  final int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    Return(),
    Add(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchBar(),
      body: _pages.elementAt(_selectedIndex),
      floatingActionButton: AddPopup(),
    );
  }
}
