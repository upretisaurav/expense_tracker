import 'package:flutter/material.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Text(
        title,
        style: TextStyles.humongous,
        textAlign: TextAlign.start,
      ),
    );
  }
}
