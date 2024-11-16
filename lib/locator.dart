import 'package:expense_tracker/src/data/dao/goal_dao.dart';
import 'package:expense_tracker/src/data/database/app_database.dart';
import 'package:expense_tracker/src/data/repository/goal_repository.dart';
import 'package:expense_tracker/src/providers/goal_provider.dart';
import 'package:expense_tracker/src/services/api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  getIt.registerSingleton<AppDatabase>(database);

  getIt.registerSingleton(database.goalDao);
  getIt.registerSingleton(GoalRepository(getIt<GoalDao>()));
  getIt.registerSingleton(GoalProvider(getIt<GoalRepository>()));
  getIt.registerSingleton<ApiService>(ApiService('http://127.0.0.1:5000'));
}
