import 'package:expense_tracker/locator.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/providers/trend_provider.dart';
import 'package:expense_tracker/src/providers/user_provider.dart';
import 'package:expense_tracker/src/services/notification_service.dart';
import 'package:expense_tracker/src/views/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  await setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrendProvider()),
        ChangeNotifierProxyProvider<TrendProvider, ExpenseProvider>(
          create: (context) => ExpenseProvider(context.read<TrendProvider>()),
          update: (context, trendProvider, previous) =>
              previous ?? ExpenseProvider(trendProvider),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: const WelcomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
