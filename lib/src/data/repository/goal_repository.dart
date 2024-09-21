import 'package:expense_tracker/src/data/dao/goal_dao.dart';
import 'package:expense_tracker/src/data/model/goal.dart';

class GoalRepository {
  final GoalDao _goalDao;

  GoalRepository(this._goalDao);

  Future<List<Goal>> getAllGoals() => _goalDao.findAllGoals();

  Future<Goal?> getGoalById(int id) => _goalDao.findGoalById(id);

  Future<void> addGoal(Goal goal) => _goalDao.insertGoal(goal);

  Future<void> updateGoal(Goal goal) => _goalDao.updateGoal(goal);

  Future<void> deleteGoal(Goal goal) => _goalDao.deleteGoal(goal);
}
