import 'dart:async';
import 'package:expense_tracker/src/data/dao/goal_dao.dart';
import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../dao/expense_dao.dart';

part 'app_database.g.dart';

@Database(version: 2, entities: [Expense, Goal])
abstract class AppDatabase extends FloorDatabase {
  ExpenseDao get expenseDao;
  GoalDao get goalDao;
}
