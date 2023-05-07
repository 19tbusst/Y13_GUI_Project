import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class SearchBar extends StatefulWidget with PreferredSizeWidget {
  const SearchBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return EasySearchBar(
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
    );
  }
}
