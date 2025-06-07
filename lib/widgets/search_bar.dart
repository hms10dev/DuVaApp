import 'package:flutter/material.dart';

/// A simple search bar used throughout the app.
///
/// The previous implementation only returned a [Placeholder] widget which
/// caused runtime errors when the [SearchBar] was instantiated with required
/// parameters. This widget now exposes a text [controller], an [onChanged]
/// callback and an optional [hintText] to mimic a real search input field.
class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
  });

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Hint text displayed inside the search field.
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
