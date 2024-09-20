import 'package:expense_tracker/src/data/database/app_database.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  getIt.registerSingleton<AppDatabase>(database);
}
