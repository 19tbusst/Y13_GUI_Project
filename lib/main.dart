// Dart packages
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Pub packages
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:desktop_window/desktop_window.dart';

// Local files
import 'firebase_options.dart';
import 'package:y13_gui_project/HomePage/home_page.dart';
import 'package:y13_gui_project/Add_Popup/add_popup.dart';
import 'package:y13_gui_project/search_bar.dart';

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

  Uint8List? fileBytes;
  void setFileBytes(Uint8List value) {
    fileBytes = value;
    notifyListeners();
  }

  // Search query
  String searchQuery = '';
  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  // Search suggestions
  List<String> searchSuggestions = [];
  void setSearchSuggestions(List<String> value) {
    searchSuggestions = value;
    notifyListeners();
  }
}

// Item class
class Item {
  String name;
  bool isIssued;
  DateTime date;
  String image;
  String id;
  String borrowerName;
  String borrowerEmail;
  DateTime dueDate;

  Item({
    required this.id,
    required this.name,
    required this.isIssued,
    required this.date,
    required this.image,
    required this.borrowerName,
    required this.borrowerEmail,
    required this.dueDate,
  });
}

void main() {
  // Set minimum window size for desktop
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      DesktopWindow.setMinWindowSize(
        const Size(410, 350),
      );
    }
  }

  // Run the asynchronous initialization function
  initializeAppAndRun();
}

Future<void> initializeAppAndRun() async {
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
    // Main app
    return const Scaffold(
      appBar: SearchBar(),
      body: HomePage(),
      floatingActionButton: AddPopup(),
    );
  }
}
