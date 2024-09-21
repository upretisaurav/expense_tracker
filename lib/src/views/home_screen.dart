import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/src/views/calculator_screen.dart';
import 'package:expense_tracker/src/views/onboarding.dart';
import 'package:expense_tracker/src/views/report_screen.dart';
import 'package:expense_tracker/widgets/generic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 24.0),
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding wrapper for the first part of the screen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "WELCOME TO",
                    style: TextStyles.smallMedium
                        .copyWith(color: ColorStyles.secondaryTextColor),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "BUDGET TRACKER",
                    style: TextStyles.humongous.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Consumer<ExpenseProvider>(
                    builder: (context, expenseProvider, child) {
                      double balance = expenseProvider.balance;

                      return Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: ColorStyles.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 90.0,
                              width: 140.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/budget_wallet.png"),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Your Balance",
                                    style: TextStyles.smallMedium
                                        .copyWith(color: ColorStyles.gray),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    "\$ $balance",
                                    style: TextStyles.humongous.copyWith(
                                        color: ColorStyles.lightGreen),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24.0),
                  // Budget actions
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: <Widget>[
                              // Cash inflow
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CalculatorPage(
                                          isInflow: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorStyles.faintBlue,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    padding: const EdgeInsets.all(24.0),
                                    margin: const EdgeInsets.only(right: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/svg/cash_inward.svg",
                                          colorFilter: const ColorFilter.mode(
                                            ColorStyles.primaryAccent,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(height: 24.0),
                                        const Text(
                                          "Add Inflow",
                                          style: TextStyles.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Cash outflow
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CalculatorPage(
                                          isInflow: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorStyles.faintBlue,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/svg/cash_outward.svg",
                                          colorFilter: ColorFilter.mode(
                                            ColorStyles.red.withOpacity(0.8),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(height: 24.0),
                                        const Text(
                                          "Add Outflow",
                                          style: TextStyles.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Full-width container for recent transactions
            Expanded(
              child: Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, child) {
                  List<Expense> latestExpenses = [...expenseProvider.expenses];
                  latestExpenses.sort((a, b) => b.date.compareTo(a.date));
                  latestExpenses = latestExpenses.take(5).toList();

                  return latestExpenses.isEmpty
                      ? const Center(
                          child: Text("No recent transactions"),
                        )
                      : Container(
                          width: double.infinity,
                          color: const Color(0xfff2f4f7),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Recent Transactions",
                                      style: TextStyles.body,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        navBarKey.currentState?.changePage(1);
                                      },
                                      child: const Text(
                                        "See All",
                                        style: TextStyle(
                                          color: ColorStyles.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: latestExpenses.length,
                                  itemBuilder: (BuildContext __, int index) {
                                    final expense = latestExpenses[index];
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 8.0),
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
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
