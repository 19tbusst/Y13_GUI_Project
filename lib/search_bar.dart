// flutter imports
import 'package:flutter/material.dart';

// Pub packages
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:provider/provider.dart';

// Local fields
import 'package:storio/main.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchBar({Key? key}) : super(key: key);

  // appBar height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    AppState appState = Provider.of<AppState>(context);

    return EasySearchBar(
      title: const Text('Stor.io'),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      searchBackgroundColor: colorScheme.surface,
      searchBackIconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
      searchCursorColor: colorScheme.primary,
      searchClearIconTheme: IconThemeData(
        color: colorScheme.error,
      ),
      searchTextStyle: TextStyle(
        color: colorScheme.onSurface,
      ),
      suggestions: appState.searchSuggestions,
      onSearch: (value) {
        appState.setSearchQuery(value);
      },
    );
  }
}
