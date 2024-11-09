import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:expense_tracker/src/providers/goal_provider.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/saving_goal_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class GoalDetailsScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final GoalProvider _goalProvider = GetIt.I<GoalProvider>();

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        DateFormat('yMMMMd').format(DateTime.parse(widget.goal.startDate));
    String formattedEndDate =
        DateFormat('yMMMMd').format(DateTime.parse(widget.goal.endDate));

    return Scaffold(
      backgroundColor: const Color(0xfff2f4f7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SavingGoalCard(
                totalSavedAmount: widget.goal.savedAmount,
                totalTargetAmount: widget.goal.targetAmount,
                date: "$formattedStartDate - $formattedEndDate",
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Category: ${widget.goal.category}',
                  style: TextStyles.body,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Lottie.asset(
                  'assets/lottie/saving.json',
                  width: 600,
                  height: 300,
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: const Text('Add to Savings'),
                  onPressed: () => _showAddSavingsDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSavingsDialog(BuildContext context) {
    double amount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Add to Savings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (value) => amount = double.tryParse(value) ?? 0,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Please enter the amount you want to add to savings.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add', style: TextStyle(fontSize: 16)),
              onPressed: () {
                if (amount > 0) {
                  _goalProvider.addToSavings(widget.goal, amount);
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
