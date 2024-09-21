import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:expense_tracker/src/data/repository/goal_repository.dart';
import 'package:flutter/material.dart';

class GoalProvider with ChangeNotifier {
  final GoalRepository _repository;

  List<Goal> _goals = [];

  GoalProvider(this._repository) {
    _fetchGoals();
  }

  List<Goal> get goals => _goals;

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
    await _repository.deleteGoal(goal);
    await _fetchGoals();
  }

  Future<void> addToSavings(Goal goal, double amount) async {
    goal.savedAmount += amount;
    await updateGoal(goal);
  }

  double get totalTargetAmount =>
      _goals.fold(0, (sum, goal) => sum + goal.targetAmount);

  double get totalSavedAmount =>
      _goals.fold(0, (sum, goal) => sum + goal.savedAmount);
}
