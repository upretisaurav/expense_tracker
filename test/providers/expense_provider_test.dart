import 'package:expense_tracker/src/data/dao/expense_dao.dart';
import 'package:expense_tracker/src/data/database/app_database.dart';
import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:expense_tracker/src/data/repository/expense_repository.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/providers/trend_provider.dart';
import 'package:expense_tracker/src/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';

import 'expense_provider_test.mocks.dart';

@GenerateMocks(
    [ExpenseRepository, TrendProvider, AppDatabase, ExpenseDao, ApiService])
void main() {
  group('ExpenseProvider Tests', () {
    late ExpenseProvider expenseProvider;
    late MockExpenseRepository mockRepository;
    late MockTrendProvider mockTrendProvider;
    late MockAppDatabase mockAppDatabase;
    late MockExpenseDao mockExpenseDao;
    late MockApiService mockApiService;

    setUp(() {
      mockRepository = MockExpenseRepository();
      mockTrendProvider = MockTrendProvider();
      mockAppDatabase = MockAppDatabase();
      mockExpenseDao = MockExpenseDao();

      final getIt = GetIt.instance;
      getIt.registerSingleton<AppDatabase>(mockAppDatabase);

      mockApiService = MockApiService();
      getIt.registerSingleton<ApiService>(mockApiService);

      when(mockAppDatabase.expenseDao).thenReturn(mockExpenseDao);
      when(mockExpenseDao.getAllExpenses()).thenAnswer((_) async => []);
      when(mockExpenseDao.getCategoriesByType(true))
          .thenAnswer((_) async => []);
      when(mockExpenseDao.getCategoriesByType(false))
          .thenAnswer((_) async => []);

      expenseProvider = ExpenseProvider(mockTrendProvider);
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    test('Initial state is correct', () async {
      expect(expenseProvider.expenses, isEmpty);
      expect(expenseProvider.categories, isEmpty);
    });

    test('Add Expense', () async {
      final testExpense = Expense(
          title: 'Test Income',
          amount: 1000.0,
          date: DateTime.now().toString(),
          isInflow: true,
          category: 'Salary');

      when(mockRepository.addExpense(testExpense)).thenAnswer((_) async {});
      when(mockExpenseDao.getAllExpenses())
          .thenAnswer((_) async => [testExpense]);

      await expenseProvider.addExpense(testExpense);

      expect(expenseProvider.expenses.length, 1);
      expect(expenseProvider.expenses.first, testExpense);
    });
  });
}
