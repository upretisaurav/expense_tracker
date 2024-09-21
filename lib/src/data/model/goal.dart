import 'package:floor/floor.dart';

@entity
class Goal {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String description;
  final double targetAmount;
  double savedAmount;
  final String startDate;
  final String endDate;
  final String category;

  Goal(
      {this.id,
      required this.name,
      required this.description,
      required this.targetAmount,
      this.savedAmount = 0,
      required this.startDate,
      required this.endDate,
      required this.category});
}
