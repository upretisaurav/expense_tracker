import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/generic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 32.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 12.0),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text("Your Report", style: TextStyles.humongous),
            const SizedBox(height: 12.0),
            Consumer<ExpenseProvider>(
              builder: (context, expenseProvider, _) {
                return ReportSummaryWidget(
                  totalInflow: expenseProvider.totalInflow,
                  totalOutflow: expenseProvider.totalOutflow,
                  balance: expenseProvider.balance,
                );
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, _) {
                  final expenses = expenseProvider.expenses;

                  if (expenses.isEmpty) {
                    return const Center(child: Text("No data available"));
                  }

                  return ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (BuildContext __, int index) {
                      final expense = expenses[index];
                      return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: BudgetWidget(
                            budgetType: expense.isInflow
                                ? BudgetType.inFlow
                                : BudgetType.outFlow,
                            source: expense.category,
                            amount: expense.amount,
                          ));
                    },
                  );
                },
              ),
            ),
          ]),
    ));
  }
}
