import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 32.0,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 24.0),
            Text("Your Goals", style: TextStyles.humongous),
            SizedBox(
              height: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}
