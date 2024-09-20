import 'package:floor/floor.dart';

@entity
class Expense {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;
  final double amount;
  final String date;
  final bool isInflow;
  final String category;

  Expense(
      {this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.isInflow,
      required this.category});
}
