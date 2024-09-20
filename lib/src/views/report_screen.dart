import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/generic.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 32.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
            const ReportSummaryWidget(),
            const SizedBox(height: 16.0),
            Flexible(
              child: ListView.builder(
                itemBuilder: (BuildContext __, int index) {
                  if (index % 3 == 0) {
                    return Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: BudgetWidget(
                            budgetType: BudgetType.outFlow,
                            source: "Outflow Source Name",
                            amount: (index + 1) * 100));
                  }

                  return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: BudgetWidget(
                          budgetType: BudgetType.inFlow,
                          source: "Inflow Source Name",
                          amount: (index + 1) * 1000));
                },
                itemCount: 24,
              ),
            )
          ]),
    ));
  }
}
