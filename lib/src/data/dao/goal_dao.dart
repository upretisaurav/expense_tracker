import 'package:expense_tracker/src/data/model/goal.dart';
import 'package:floor/floor.dart';

@dao
abstract class GoalDao {
  @Query('SELECT * FROM Goal')
  Future<List<Goal>> findAllGoals();

  @Query('SELECT * FROM Goal WHERE id = :id')
  Future<Goal?> findGoalById(int id);

  @insert
  Future<void> insertGoal(Goal goal);

  @insert
  Future<void> insertGoals(List<Goal> goals);

  @update
  Future<void> updateGoal(Goal goal);

  @delete
  Future<void> deleteGoal(Goal goal);
}
