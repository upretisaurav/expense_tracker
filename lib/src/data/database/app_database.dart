import 'dart:async';
import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../dao/expense_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Expense])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;
}
