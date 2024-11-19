import 'package:expense_tracker/src/views/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/providers/trend_provider.dart';

import '../helpers/test_helper.dart';

void main() {
  final mockExpenseProvider = MockExpenseProvider();
  final mockTrendProvider = MockTrendProvider();

  Widget createTestableWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExpenseProvider>.value(
            value: mockExpenseProvider),
        ChangeNotifierProvider<TrendProvider>.value(value: mockTrendProvider),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('Initial UI elements are displayed correctly',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestableWidget(const CalculatorPage(isInflow: true)));

    expect(find.text('AMOUNT'), findsOneWidget);
    expect(find.text('Select Source'), findsOneWidget);
    expect(find.text('ADD'), findsOneWidget);
  });

  testWidgets('Clear button works', (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestableWidget(const CalculatorPage(isInflow: true)));

    await tester.tap(find.text('7'));
    await tester.tap(find.text('5'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();

    final inputField = find.byType(TextField);
    expect((tester.widget(inputField) as TextField).controller!.text, '7');
  });

  testWidgets('AC button works', (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestableWidget(const CalculatorPage(isInflow: true)));

    await tester.tap(find.text('7'));
    await tester.tap(find.text('5'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    final inputField = find.byType(TextField);
    expect((tester.widget(inputField) as TextField).controller!.text, '');
  });
}
