import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/saving_gauge.dart';
import 'package:flutter/material.dart';

class SavingGoalCard extends StatelessWidget {
  final double totalSavedAmount;
  final double totalTargetAmount;
  final String? date;
  const SavingGoalCard({
    super.key,
    required this.totalSavedAmount,
    required this.totalTargetAmount,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Saving Goal",
                  style: TextStyles.body,
                ),
                const SizedBox(height: 8.0),
                (date != null && date!.isNotEmpty)
                    ? Text(
                        "Date from $date",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(height: 84.0),
            Center(
              child: CustomPaint(
                size: const Size(300, 100),
                painter: HalfCirclePainter(
                  saved: totalSavedAmount,
                  target: totalTargetAmount,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}
