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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'date': date,
        'isInflow': isInflow,
        'category': category,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'],
        title: json['title'],
        amount: json['amount'],
        date: json['date'],
        isInflow: json['isInflow'],
        category: json['category'],
      );
}
