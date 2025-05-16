// lib/Screens/tracking/Widgets/search.dart

import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isDarkMode;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: 'Search by BIB or name...',
        hintStyle:
            TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[700]),
        prefixIcon: Icon(Icons.search,
            color: isDarkMode ? Colors.white70 : Colors.grey),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      ),
    );
  }
}
