import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:floor/floor.dart';

@dao
abstract class ExpenseDao {
  @Query('SELECT * FROM Expense')
  Future<List<Expense>> getAllExpenses();

  @Query('SELECT * FROM Expense WHERE isInflow = :isInflow')
  Future<List<Expense>> getExpensesByType(bool isInflow);

  @Query('SELECT * FROM Expense WHERE category = :category')
  Future<List<Expense>> getExpensesByCategory(String category);

  @Query('SELECT DISTINCT category FROM Expense WHERE isInflow = :isInflow')
  Future<List<String>> getCategoriesByType(bool isInflow);

  @insert
  Future<void> insertExpense(Expense expense);

  @update
  Future<void> updateExpense(Expense expense);

  @delete
  Future<void> deleteExpense(Expense expense);
}
