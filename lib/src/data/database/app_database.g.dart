// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  GoalDao? _goalDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Expense` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `amount` REAL NOT NULL, `date` TEXT NOT NULL, `isInflow` INTEGER NOT NULL, `category` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Goal` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `targetAmount` REAL NOT NULL, `savedAmount` REAL NOT NULL, `startDate` TEXT NOT NULL, `endDate` TEXT NOT NULL, `category` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }

  @override
  GoalDao get goalDao {
    return _goalDaoInstance ??= _$GoalDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expenseInsertionAdapter = InsertionAdapter(
            database,
            'Expense',
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'date': item.date,
                  'isInflow': item.isInflow ? 1 : 0,
                  'category': item.category
                }),
        _expenseUpdateAdapter = UpdateAdapter(
            database,
            'Expense',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'date': item.date,
                  'isInflow': item.isInflow ? 1 : 0,
                  'category': item.category
                }),
        _expenseDeletionAdapter = DeletionAdapter(
            database,
            'Expense',
            ['id'],
            (Expense item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'amount': item.amount,
                  'date': item.date,
                  'isInflow': item.isInflow ? 1 : 0,
                  'category': item.category
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final UpdateAdapter<Expense> _expenseUpdateAdapter;

  final DeletionAdapter<Expense> _expenseDeletionAdapter;

  @override
  Future<List<Expense>> getAllExpenses() async {
    return _queryAdapter.queryList('SELECT * FROM Expense',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: row['date'] as String,
            isInflow: (row['isInflow'] as int) != 0,
            category: row['category'] as String));
  }

  @override
  Future<List<Expense>> getExpensesByType(bool isInflow) async {
    return _queryAdapter.queryList('SELECT * FROM Expense WHERE isInflow = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: row['date'] as String,
            isInflow: (row['isInflow'] as int) != 0,
            category: row['category'] as String),
        arguments: [isInflow ? 1 : 0]);
  }

  @override
  Future<List<Expense>> getExpensesByCategory(String category) async {
    return _queryAdapter.queryList('SELECT * FROM Expense WHERE category = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: row['date'] as String,
            isInflow: (row['isInflow'] as int) != 0,
            category: row['category'] as String),
        arguments: [category]);
  }

  @override
  Future<List<String>> getCategoriesByType(bool isInflow) async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT category FROM Expense WHERE isInflow = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [isInflow ? 1 : 0]);
  }

  @override
  Future<List<Expense>> getExpensesBetweenDates(
    String startDate,
    String endDate,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Expense WHERE date BETWEEN ?1 AND ?2',
        mapper: (Map<String, Object?> row) => Expense(
            id: row['id'] as int?,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: row['date'] as String,
            isInflow: (row['isInflow'] as int) != 0,
            category: row['category'] as String),
        arguments: [startDate, endDate]);
  }

  @override
  Future<double?> getTotalBetweenDates(
    bool isInflow,
    String startDate,
    String endDate,
  ) async {
    return _queryAdapter.query(
        'SELECT SUM(amount) FROM Expense WHERE isInflow = ?1 AND date BETWEEN ?2 AND ?3',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [isInflow ? 1 : 0, startDate, endDate]);
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    await _expenseInsertionAdapter.insert(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _expenseUpdateAdapter.update(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    await _expenseDeletionAdapter.delete(expense);
  }
}

class _$GoalDao extends GoalDao {
  _$GoalDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _goalInsertionAdapter = InsertionAdapter(
            database,
            'Goal',
            (Goal item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'targetAmount': item.targetAmount,
                  'savedAmount': item.savedAmount,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'category': item.category
                }),
        _goalUpdateAdapter = UpdateAdapter(
            database,
            'Goal',
            ['id'],
            (Goal item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'targetAmount': item.targetAmount,
                  'savedAmount': item.savedAmount,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'category': item.category
                }),
        _goalDeletionAdapter = DeletionAdapter(
            database,
            'Goal',
            ['id'],
            (Goal item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'targetAmount': item.targetAmount,
                  'savedAmount': item.savedAmount,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'category': item.category
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Goal> _goalInsertionAdapter;

  final UpdateAdapter<Goal> _goalUpdateAdapter;

  final DeletionAdapter<Goal> _goalDeletionAdapter;

  @override
  Future<List<Goal>> findAllGoals() async {
    return _queryAdapter.queryList('SELECT * FROM Goal',
        mapper: (Map<String, Object?> row) => Goal(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            targetAmount: row['targetAmount'] as double,
            savedAmount: row['savedAmount'] as double,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            category: row['category'] as String));
  }

  @override
  Future<Goal?> findGoalById(int id) async {
    return _queryAdapter.query('SELECT * FROM Goal WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Goal(
            id: row['id'] as int?,
            name: row['name'] as String,
            description: row['description'] as String,
            targetAmount: row['targetAmount'] as double,
            savedAmount: row['savedAmount'] as double,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            category: row['category'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertGoal(Goal goal) async {
    await _goalInsertionAdapter.insert(goal, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertGoals(List<Goal> goals) async {
    await _goalInsertionAdapter.insertList(goals, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    await _goalUpdateAdapter.update(goal, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGoal(Goal goal) async {
    await _goalDeletionAdapter.delete(goal);
  }
}
