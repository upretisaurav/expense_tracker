import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/src/views/calculator_screen.dart';
import 'package:expense_tracker/src/views/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 24.0),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
              style: TextStyles.humongous.copyWith(fontWeight: FontWeight.w900),
            ),
            Container(
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
                        image: AssetImage("assets/images/budget_wallet.png"),
                      )),
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
                            "\$0.00",
                            style: TextStyles.humongous
                                .copyWith(color: ColorStyles.lightGreen),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            const SizedBox(height: 24.0),
            Expanded(
              child: Column(
                children: <Widget>[
                  //budget actions
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: <Widget>[
                          //cash inFlow
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CalculatorPage(),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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

                          //cash outflow
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CalculatorPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorStyles.faintBlue,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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

                  //report
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ReportPage()));
                      },
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorStyles.faintBlue,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  "assets/svg/report.svg",
                                  colorFilter: const ColorFilter.mode(
                                    ColorStyles.primaryAccent,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                const Text(
                                  "Report",
                                  style: TextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
