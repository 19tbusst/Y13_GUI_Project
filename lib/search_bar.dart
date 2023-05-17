import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchBar({Key? key}) : super(key: key);

  // appBar height
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return PreferredSize(
      preferredSize: preferredSize,
      child: SizedBox(
        // set height of appBar
        height: preferredSize.height,

        // SearchBar widget
        child: EasySearchBar(
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
          onSearch: (value) {
            // TODO: Implement search
            print(value);
          },
        ),
      ),
    );
  }
}
