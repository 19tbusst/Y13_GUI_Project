import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'firebase_options.dart';

import 'package:y13_gui_project/HomePage/home_page.dart';
import 'package:y13_gui_project/Add/add.dart';
import 'package:y13_gui_project/Return/return.dart';
import 'package:y13_gui_project/Add_Popup/add_popup.dart';
import 'package:y13_gui_project/app_bar.dart';

class AppState extends ChangeNotifier {
  bool isShowingIssued = true;
  bool isShowingReturned = true;

  String sortingMode = 'name_az';

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
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

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

  String _searchValue = '';

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    Return(),
    Add(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        title: const Text('Stor.io'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        searchBackgroundColor: Theme.of(context).colorScheme.surface,
        searchBackIconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.primary),
        searchCursorColor: Theme.of(context).colorScheme.primary,
        searchClearIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.error,
        ),
        searchTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onSearch: (value) => setState(() => _searchValue = value),
      ),
      body: _pages.elementAt(_selectedIndex),
      floatingActionButton: const AddPopup(),
    );
  }
}
