import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:desktop_window/desktop_window.dart';
import 'firebase_options.dart';

import 'package:y13_gui_project/HomePage/home_page.dart';
import 'package:y13_gui_project/Add/add.dart';
import 'package:y13_gui_project/Return/return.dart';
import 'package:y13_gui_project/Add_Popup/add_popup.dart';

class AppState extends ChangeNotifier {
  bool isShowingIssued = true;
  bool isShowingReturned = true;

  String sortingMode = 'name_az';

  void setSortingMode(String mode) {
    sortingMode = mode;
    notifyListeners();
  }

  String? result = '';
  void setResult(String? value) {
    result = value;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMinWindowSize(
      const Size(410, 350),
    );
  }

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
  String _searchValue = '';

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
      body: const HomePage(),
      floatingActionButton: const AddPopup(),
    );
  }
}
