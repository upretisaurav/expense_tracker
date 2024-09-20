import 'package:expense_tracker/locator.dart';
import 'package:expense_tracker/src/data/model/expense.dart';
import '../database/app_database.dart';

class ExpenseRepository {
  final expenseDao = getIt<AppDatabase>().expenseDao;

  Future<List<Expense>> getAllExpenses() => expenseDao.getAllExpenses();

  Future<List<Expense>> getExpensesByType(bool isInflow) =>
      expenseDao.getExpensesByType(isInflow);

  Future<List<Expense>> getExpensesByCategory(String category) =>
      expenseDao.getExpensesByCategory(category);

  Future<List<String>> getCategoriesByType(bool isInflow) =>
      expenseDao.getCategoriesByType(isInflow);

  Future<void> addExpense(Expense expense) => expenseDao.insertExpense(expense);

  Future<void> updateExpense(Expense expense) =>
      expenseDao.updateExpense(expense);

  Future<void> deleteExpense(Expense expense) =>
      expenseDao.deleteExpense(expense);
}
