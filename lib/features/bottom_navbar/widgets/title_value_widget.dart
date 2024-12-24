import 'package:flutter/material.dart';
import 'package:map_based_search/core/utils/app_color.dart';

class TitleValueWidget extends StatelessWidget {
  final String text;
  const TitleValueWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
    );
  }
}