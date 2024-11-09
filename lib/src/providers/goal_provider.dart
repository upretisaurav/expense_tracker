import 'dart:async';
import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:expense_tracker/src/data/repository/goal_repository.dart';
import 'package:flutter/material.dart';

class GoalProvider with ChangeNotifier {
  final GoalRepository _repository;
  List<Goal> _goals = [];
  final Map<String, Timer> _automatedSavingsTimers = {};

  GoalProvider(this._repository) {
    _fetchGoals();
  }

  List<Goal> get goals => _goals;

  bool isGoalAutomated(Goal goal) =>
      _automatedSavingsTimers.containsKey(goal.id.toString());

  List<Goal> get automatedGoals => _goals
      .where((goal) => _automatedSavingsTimers.containsKey(goal.id.toString()))
      .toList();

  Future<void> _fetchGoals() async {
    _goals = await _repository.getAllGoals();
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    await _repository.addGoal(goal);
    await _fetchGoals();
  }

  Future<void> updateGoal(Goal goal) async {
    await _repository.updateGoal(goal);
    await _fetchGoals();
  }

  Future<void> deleteGoal(Goal goal) async {
    cancelAutomatedSaving(goal);
    await _repository.deleteGoal(goal);
    await _fetchGoals();
  }

  Future<void> addToSavings(Goal goal, double amount) async {
    if (amount <= 0) return;

    final newAmount = goal.savedAmount + amount;
    if (newAmount > goal.targetAmount) {
      goal.savedAmount = goal.targetAmount;
      cancelAutomatedSaving(goal);
    } else {
      goal.savedAmount = newAmount;
    }

    await updateGoal(goal);
  }

  double get totalTargetAmount =>
      _goals.fold(0, (sum, goal) => sum + goal.targetAmount);

  double get totalSavedAmount =>
      _goals.fold(0, (sum, goal) => sum + goal.savedAmount);

  void scheduleAutomatedSaving(Goal goal, double amount, Duration interval) {
    cancelAutomatedSaving(goal);

    if (amount <= 0 || interval.inSeconds <= 0) return;
    if (goal.savedAmount >= goal.targetAmount) return;

    _automatedSavingsTimers[goal.id.toString()] =
        Timer.periodic(interval, (timer) async {
      final currentGoal = _goals.firstWhere(
        (g) => g.id == goal.id,
        orElse: () => goal,
      );

      if (currentGoal.savedAmount >= currentGoal.targetAmount) {
        cancelAutomatedSaving(currentGoal);
        return;
      }

      final remainingAmount =
          currentGoal.targetAmount - currentGoal.savedAmount;
      final saveAmount = amount > remainingAmount ? remainingAmount : amount;

      try {
        await addToSavings(currentGoal, saveAmount);
      } catch (e) {
        debugPrint('Error in automated saving: $e');
      }
    });

    notifyListeners();
  }

  void cancelAutomatedSaving(Goal goal) {
    if (_automatedSavingsTimers.containsKey(goal.id.toString())) {
      _automatedSavingsTimers[goal.id.toString()]?.cancel();
      _automatedSavingsTimers.remove(goal.id.toString());
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var timer in _automatedSavingsTimers.values) {
      timer.cancel();
    }
    _automatedSavingsTimers.clear();
    super.dispose();
  }
}
