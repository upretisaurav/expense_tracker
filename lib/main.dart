import 'package:expense_tracker/locator.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/views/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
      child: const MaterialApp(
        home: WelcomePage(),
      ),
    );
  }
}
