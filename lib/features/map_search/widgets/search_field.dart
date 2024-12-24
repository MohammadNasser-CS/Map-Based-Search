import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final Function(String) onSubmit;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search for a place or category...',
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: onSearch,
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: onSubmit,
          ),
        ),
      ),
    );
  }
}
