import 'package:expense_tracker/src/data/database/app_database.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/src/data/repository/expense_repository.dart';
import 'package:expense_tracker/src/providers/trend_provider.dart';
import 'package:expense_tracker/src/data/dao/expense_dao.dart';

// Create mock classes for easier testing
class MockExpenseRepository extends Mock implements ExpenseRepository {}

class MockExpenseProvider extends Mock implements ExpenseProvider {}

class MockTrendProvider extends Mock implements TrendProvider {}

// Mock ExpenseDao
class MockExpenseDao extends Mock implements ExpenseDao {}

// Mock AppDatabase
class MockAppDatabase extends Mock implements AppDatabase {
  final MockExpenseDao _mockExpenseDao = MockExpenseDao();

  // Override the expenseDao getter to return the mock
  @override
  ExpenseDao get expenseDao => _mockExpenseDao;
}

void setupTestDependencies() {
  final getIt = GetIt.instance;

  // Create a mock database instance
  final mockAppDatabase = MockAppDatabase();

  // Register the mock database for testing
  getIt.registerSingleton<AppDatabase>(mockAppDatabase);
}

void resetTestDependencies() {
  final getIt = GetIt.instance;
  getIt.reset();
}
