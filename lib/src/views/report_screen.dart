import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/generic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Expense> _filteredExpenses = [];
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _filterExpenses("This Month");
  }

  void _filterExpenses(String period) async {
    final now = DateTime.now();
    DateTimeRange dateRange;

    switch (period) {
      case "This Month":
        dateRange = DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );
        break;
      case "Previous Month":
        final previousMonth = DateTime(now.year, now.month - 1, 1);
        dateRange = DateTimeRange(
          start: DateTime(previousMonth.year, previousMonth.month, 1),
          end: DateTime(previousMonth.year, previousMonth.month + 1, 0),
        );
        break;
      case "This Year":
        dateRange = DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, 12, 31),
        );
        break;
      default:
        dateRange = DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
    }

    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    final expenses =
        await provider.getExpensesBetweenDates(dateRange.start, dateRange.end);

    // Sort the expenses by date in descending order (most recent first)
    expenses.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _filteredExpenses = expenses;
      _selectedRange = dateRange;
    });
  }

  String getFormattedDateRange() {
    if (_selectedRange == null) return '';
    final formatter = DateFormat('MMM d, yyyy');
    return '${formatter.format(_selectedRange!.start)} - ${formatter.format(_selectedRange!.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f4f7),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 32.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24.0),
            const Text("Your Report", style: TextStyles.humongous),
            const SizedBox(height: 24.0),

            // Summary widget
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColorStyles.primaryColor,
                    ),
                  ),
                  onPressed: () => _filterExpenses("This Month"),
                  child: const Text("This Month"),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColorStyles.primaryColor,
                    ),
                  ),
                  onPressed: () => _filterExpenses("Previous Month"),
                  child: const Text("Previous Month"),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColorStyles.primaryColor,
                    ),
                  ),
                  onPressed: () => _filterExpenses("This Year"),
                  child: const Text("This Year"),
                ),
              ],
            ),

            const SizedBox(height: 8.0),

            if (_selectedRange != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Text(
                  'Showing data for: ${getFormattedDateRange()}',
                  style: TextStyles.smallMedium,
                ),
              ),

            const SizedBox(height: 20.0),

            // List of filtered inflows and outflows
            Expanded(
              child: _filteredExpenses.isEmpty
                  ? const Center(
                      child: Text("No data available for the selected range"))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _filteredExpenses.length,
                      itemBuilder: (BuildContext __, int index) {
                        final expense = _filteredExpenses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: BudgetWidget(
                            budgetType: expense.isInflow
                                ? BudgetType.inFlow
                                : BudgetType.outFlow,
                            source: expense.category,
                            amount: expense.amount,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
