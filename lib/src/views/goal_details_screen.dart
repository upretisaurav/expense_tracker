import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:expense_tracker/src/providers/goal_provider.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/saving_goal_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class GoalDetailsScreen extends StatefulWidget {
  final Goal goal;

  GoalDetailsScreen({super.key, required this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
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
          title: const Text('Add to Savings'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
            onChanged: (value) => amount = double.tryParse(value) ?? 0,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (amount > 0) {
                  _goalProvider.addToSavings(widget.goal, amount);
                  setState(() {}); // Update the UI to reflect new saved amount
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
