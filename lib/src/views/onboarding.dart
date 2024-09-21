import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/src/views/custom_nav_bar.dart';
import 'package:expense_tracker/widgets/buttons.dart';
import 'package:expense_tracker/widgets/generic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final GlobalKey<CustomNavBarState> navBarKey = GlobalKey<CustomNavBarState>();

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/wallet.png"),
                )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(bottom: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Welcome to Budget Tracker",
                      style: TextStyles.humongous,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Keep Record of all your Expenses and Income.\nTrack, analyse and act.",
                      style: TextStyles.smallMedium
                          .copyWith(color: ColorStyles.secondaryTextColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 44.0),
                    PrimaryButton(
                      buttonText: "START",
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const AppIntroPage();
                        }), (route) {
                          return true;
                        });
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppIntroPage extends StatefulWidget {
  const AppIntroPage({super.key});

  @override
  State<AppIntroPage> createState() => _AppIntroPageState();
}

class _AppIntroPageState extends State<AppIntroPage> {
  final _controller = PageController();

  late SharedPreferences sharedPreferences;
  bool? isFirstTime = true;
  bool hasEndReached = false;

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = sharedPreferences.getBool("isFirstTime");
      // if (!isFirstTime ?? false) {
      //   //todo go to home page;
      // }
    });
  }

  @override
  void initState() {
    getCredential();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 52.0),
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: PageView(
              controller: _controller,
              onPageChanged: (int index) {
                //statically typed value for now
                if (index == 2) {
                  hasEndReached = true;
                } else {
                  hasEndReached = false;
                }
              },
              children: <Widget>[
                //todo: change the app intro contents here
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: const IntroWidget(
                    imageAssetPath: "assets/images/track_expense.png",
                    title: "Track Buget",
                    content:
                        "Manage all your transactions at one place. Add Inflow, Expenses and track them throughout the history.",
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: const IntroWidget(
                    imageAssetPath: "assets/images/track_expense.png",
                    title: "Generate Report",
                    content:
                        "Manage all your transactions at one place. Add Inflow, Expenses and track them throughout the history.",
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: const IntroWidget(
                    imageAssetPath: "assets/images/track_expense.png",
                    title: "Take Action",
                    content:
                        "Manage all your transactions at one place. Add Inflow, Expenses and track them throughout the history.",
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              height: MediaQuery.of(context).size.height / 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //skip the app introduction
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        sharedPreferences.setBool("isFirstTime", false);
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CustomNavBar(
                            key: navBarKey,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Text("Skip",
                            style: TextStyles.bodyMedium
                                .copyWith(color: ColorStyles.gray)),
                      ],
                    ),
                  ),

                  SmoothPageIndicator(
                    controller: _controller, // PageController
                    count: 3, // Number of pages
                    effect: const ScrollingDotsEffect(
                      activeDotColor: ColorStyles.primaryAccent,
                      dotColor: ColorStyles.background,
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      spacing: 4.0,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (!hasEndReached) {
                        _controller.nextPage(
                            duration: kTabScrollDuration, curve: Curves.ease);
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => CustomNavBar(
                              key: navBarKey,
                            ),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Next",
                          style: TextStyles.bodyMedium
                              .copyWith(color: ColorStyles.primaryAccent),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 25,
                          color: ColorStyles.primaryAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
