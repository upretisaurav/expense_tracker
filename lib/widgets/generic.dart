import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  final String imageAssetPath;
  final String title;
  final String content;

  const IntroWidget({
    super.key,
    required this.imageAssetPath,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imageAssetPath), fit: BoxFit.contain)),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 44.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, style: TextStyles.humongous),
                const SizedBox(height: 24.0),
                Text(
                  content,
                  style: TextStyles.smallMedium.copyWith(
                    color: ColorStyles.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ReportSummaryWidget extends StatelessWidget {
  final double totalInflow;
  final double totalOutflow;
  final double balance;
  const ReportSummaryWidget(
      {super.key,
      required this.totalInflow,
      required this.totalOutflow,
      required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: ColorStyles.lightGreen.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                reportContent("INFLOW", "\$${totalInflow.toStringAsFixed(2)}"),
                reportContent(
                    "OUTFLOW", " \$${totalOutflow.toStringAsFixed(2)}"),
                reportContent("BALANCE", "\$${balance.toStringAsFixed(2)}"),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget reportContent(String name, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            name,
            style:
                TextStyles.smallMedium.copyWith(color: ColorStyles.lightGreen),
          ),
          const SizedBox(height: 4.0),
          Text(
            amount,
            style: TextStyles.bodyBold,
          )
        ],
      ),
    );
  }
}

enum BudgetType {
  inFlow,
  outFlow,
}

class BudgetWidget extends StatelessWidget {
  final BudgetType budgetType;
  final String source;
  final double amount;

  const BudgetWidget({
    super.key,
    required this.budgetType,
    required this.source,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: ColorStyles.background,
      ),
      child: ListTile(
        leading: Container(
          height: 44.0,
          width: 44.0,
          decoration: BoxDecoration(
            color: ((budgetType == BudgetType.inFlow)
                    ? ColorStyles.lightGreen
                    : ColorStyles.red)
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Center(
            child: Icon(
              (budgetType == BudgetType.inFlow)
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: ((budgetType == BudgetType.inFlow)
                  ? ColorStyles.lightGreen
                  : ColorStyles.red),
            ),
          ),
        ),
        title: Text(
          (budgetType == BudgetType.inFlow) ? "RECEIVED FROM" : "SPENT ON",
          style: TextStyles.smallMedium
              .copyWith(color: ColorStyles.secondaryTextColor),
        ),
        subtitle: Text(source, style: TextStyles.body),
        trailing: Text(
          "${(budgetType == BudgetType.inFlow) ? "+" : "-"}\$${amount.toString()}",
          style: TextStyles.body.copyWith(
            color: ((budgetType == BudgetType.inFlow)
                ? ColorStyles.lightGreen
                : ColorStyles.red),
          ),
        ),
      ),
    );
  }
}
