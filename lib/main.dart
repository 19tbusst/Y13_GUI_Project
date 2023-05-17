// Dart packages
import 'package:flutter/material.dart';
import 'dart:io';

// Pub packages
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:y13_gui_project/seatch_bar.dart';

// Local files
import 'firebase_options.dart';
import 'package:y13_gui_project/HomePage/home_page.dart';
import 'package:y13_gui_project/Add_Popup/add_popup.dart';

class AppState extends ChangeNotifier {
  // Allows filtering of items across files
  bool isShowingIssued = true;
  bool isShowingReturned = true;

  // Changes sorting mode across files
  String sortingMode = 'name_az';

  // File uploaded via image popup form
  File? file = File('');
  void setFile(File? value) {
    file = value;
    notifyListeners();
  }
}

void main() async {
  // Set minimum window size for desktop
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMinWindowSize(
      const Size(410, 350),
    );
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Provider for state management
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SearchBar(),
      body: HomePage(),
      floatingActionButton: AddPopup(),
    );
  }
}
