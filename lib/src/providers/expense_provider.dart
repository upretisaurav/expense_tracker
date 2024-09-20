import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:expense_tracker/src/data/repository/expense_repository.dart';
import 'package:flutter/foundation.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _repository = ExpenseRepository();
  List<Expense> _expenses = [];
  List<String> _categories = [];

  List<Expense> get expenses => _expenses;
  List<String> get categories => _categories;

  Future<void> fetchExpenses() async {
    _expenses = await _repository.getAllExpenses();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    final inflowCategories = await _repository.getCategoriesByType(true);
    final outflowCategories = await _repository.getCategoriesByType(false);
    _categories = [...inflowCategories, ...outflowCategories].toSet().toList();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _repository.addExpense(expense);
    await fetchExpenses();
    await fetchCategories();
  }

  Future<void> updateExpense(Expense expense) async {
    await _repository.updateExpense(expense);
    await fetchExpenses();
    await fetchCategories();
  }

  Future<void> deleteExpense(Expense expense) async {
    await _repository.deleteExpense(expense);
    await fetchExpenses();
    await fetchCategories();
  }

  Future<List<Expense>> getExpensesBetweenDates(
      DateTime startDate, DateTime endDate) async {
    return await _repository.getExpensesBetweenDates(startDate, endDate);
  }

  Future<double> getTotalBetweenDates(
      bool isInflow, DateTime startDate, DateTime endDate) async {
    return await _repository.getTotalBetweenDates(isInflow, startDate, endDate);
  }

  Future<Map<String, double>> getCategoryTotalsBetweenDates(
      DateTime startDate, DateTime endDate) async {
    final expenses = await getExpensesBetweenDates(startDate, endDate);
    final categoryTotals = <String, double>{};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  double getTotalByCategory(String category) {
    return getExpensesByCategory(category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  List<String> getCategoriesByType(bool isInflow) {
    return _expenses
        .where((expense) => expense.isInflow == isInflow)
        .map((expense) => expense.category)
        .toSet()
        .toList();
  }

  double get totalInflow => _expenses
      .where((e) => e.isInflow)
      .fold(0, (sum, expense) => sum + expense.amount);

  double get totalOutflow => _expenses
      .where((e) => !e.isInflow)
      .fold(0, (sum, expense) => sum + expense.amount);

  double get balance => totalInflow - totalOutflow;
}
