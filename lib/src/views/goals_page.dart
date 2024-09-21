import 'dart:math';
import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:expense_tracker/src/providers/goal_provider.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/src/views/goal_details_screen.dart';
import 'package:expense_tracker/widgets/saving_goal_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GoalsPage extends StatelessWidget {
  GoalsPage({super.key});
  final GoalProvider _goalProvider = GetIt.I<GoalProvider>();

  final Map<String, IconData> _categoryIcons = {
    'House': Icons.home,
    'Car': Icons.directions_car,
    'Vacation': Icons.airplanemode_active,
    'Education': Icons.school,
    'Emergency Fund': Icons.warning,
    'Other': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f4f7),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 32.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Your Goals", style: TextStyles.humongous),
                IconButton(
                  onPressed: () => _showNotificationDialog(context),
                  icon: const Icon(Icons.notifications),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            AnimatedBuilder(
              animation: _goalProvider,
              builder: (context, child) {
                return SavingGoalCard(
                  totalSavedAmount: _goalProvider.totalSavedAmount,
                  totalTargetAmount: _goalProvider.totalTargetAmount,
                );
              },
            ),
            const SizedBox(
              height: 12.0,
            ),
            AnimatedBuilder(
              animation: _goalProvider,
              builder: (context, child) {
                if (_goalProvider.goals.isEmpty) {
                  return _buildNoGoalsMessage();
                } else {
                  return _buildGoalsOverview();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorStyles.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => _showAddGoalDialog(context),
      ),
    );
  }

  Widget _buildNoGoalsMessage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        children: [
          Text(
            "You don't have any saving goals yet.",
            style: TextStyles.body,
          ),
          SizedBox(height: 8.0),
          Text(
            "Tap the + button to add a new goal!",
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsOverview() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: _goalProvider.goals.length,
        itemBuilder: (context, index) {
          final goal = _goalProvider.goals[index];
          return _buildGoalCard(context, goal);
        },
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, Goal goal) {
    final progress = goal.savedAmount / goal.targetAmount;
    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

    final IconData iconData = _categoryIcons[goal.category] ?? Icons.star;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailsScreen(goal: goal),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: randomColor,
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                goal.name,
                style: TextStyles.body.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${goal.savedAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
                style: TextStyles.smallMedium.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                minHeight: 5,
                value: progress,
                backgroundColor: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress < 0.5 ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: TextStyles.body.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    double targetAmount = 0;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 365));
    String category = 'Other';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Add New Goal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Goal Name',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                    onSaved: (value) => name = value!,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onSaved: (value) => description = value ?? '',
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Target Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an amount' : null,
                    onSaved: (value) => targetAmount = double.parse(value!),
                  ),
                  const SizedBox(height: 12.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    value: category,
                    items: [
                      'House',
                      'Car',
                      'Vacation',
                      'Education',
                      'Emergency Fund',
                      'Other'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      category = newValue!;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Start Date: ${startDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != startDate) {
                            startDate = picked;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text("Select Start Date"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "End Date: ${endDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != endDate) {
                            endDate = picked;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text("Select End Date"),
                      ),
                    ],
                  ),
                ],
              ),
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
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  _goalProvider.addGoal(Goal(
                    name: name,
                    description: description,
                    targetAmount: targetAmount,
                    startDate: startDate.toIso8601String(),
                    endDate: endDate.toIso8601String(),
                    category: category,
                  ));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNotificationDialog(BuildContext context) async {
    int? reminders = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Savings Reminders',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'How many times do you want to be reminded to save money today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(1),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text('1'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(2),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text('2'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(3),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text('3'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (reminders != null) {}
  }
}
