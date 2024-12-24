import 'package:flutter/material.dart';
import 'package:map_based_search/features/bottom_navbar/widgets/title_value_widget.dart';

class AppBarTitleForUser extends StatelessWidget {
  final int index;
  const AppBarTitleForUser({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return index == 0
        ? const TitleValueWidget(text: 'Home')
        : index == 1
            ? const TitleValueWidget(text: 'Search')
            : index == 2
                ? const TitleValueWidget(text: 'Book Marks')
                : const TitleValueWidget(text: 'Me');
  }
}
