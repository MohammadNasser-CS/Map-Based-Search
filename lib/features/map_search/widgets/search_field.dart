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
      top: 10,
      left: 10,
      right: 10,
      child: Opacity(
        opacity: 0.9,
        child: Card(
          elevation: 5,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsetsDirectional.symmetric(vertical: 0, horizontal: 10),
              hintText: 'Search for a place or category...',
              hintStyle: TextStyle(fontSize: 14),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 18,
                ),
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
