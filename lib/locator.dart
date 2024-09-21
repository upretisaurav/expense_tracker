import 'package:expense_tracker/src/data/dao/goal_dao.dart';
import 'package:expense_tracker/src/data/database/app_database.dart';
import 'package:expense_tracker/src/data/repository/goal_repository.dart';
import 'package:expense_tracker/src/providers/goal_provider.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  getIt.registerSingleton<AppDatabase>(database);

  getIt.registerSingleton(database.goalDao);
  getIt.registerSingleton(GoalRepository(getIt<GoalDao>()));
  getIt.registerSingleton(GoalProvider(getIt<GoalRepository>()));
}
