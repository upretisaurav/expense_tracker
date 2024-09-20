import 'package:expense_tracker/src/data/model/expense.dart';
import 'package:expense_tracker/src/providers/expense_provider.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatefulWidget {
  final bool isInflow;
  const CalculatorPage({super.key, required this.isInflow});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String amount = "";
  String amountSource = "";
  final textControllerInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> inflowOptions = ['Salary', 'Bonus', 'Investment', 'Gift'];
  List<String> outflowOptions = [
    'Groceries',
    'Rent',
    'Utilities',
    'Entertainment'
  ];

  @override
  void initState() {
    super.initState();
    textControllerInput.addListener(() {
      setState(() {
        amount = textControllerInput.text;
      });
    });
  }

  @override
  void dispose() {
    textControllerInput.dispose();
    super.dispose();
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate() &&
        amount.isNotEmpty &&
        amountSource.isNotEmpty) {
      _formKey.currentState!.save();

      final expense = Expense(
        title: amountSource,
        amount: double.tryParse(amount) ?? 0,
        date: DateTime.now().toString(),
        isInflow: widget.isInflow,
        category: amountSource,
      );

      Provider.of<ExpenseProvider>(context, listen: false)
          .addExpense(expense)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${widget.isInflow ? "Income" : "Expense"} added successfully'),
          ),
        );
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount and source')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                margin: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          height: 100.0,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: widget.isInflow
                                ? ColorStyles.lightGreen.withOpacity(0.2)
                                : ColorStyles.red.withOpacity(0.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("AMOUNT",
                                  style: TextStyles.smallMedium.copyWith(
                                      color: ColorStyles.secondaryTextColor)),
                              const SizedBox(height: 4.0),
                              TextField(
                                decoration: const InputDecoration.collapsed(
                                    hintText: "0",
                                    hintStyle: TextStyles.humongous),
                                style: TextStyles.humongous,
                                textAlign: TextAlign.center,
                                controller: textControllerInput,
                                onTap: () => FocusScope.of(context)
                                    .requestFocus(FocusNode()),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  child: DropdownButtonFormField<String>(
                    value: null, // Initial value
                    hint: const Text("Select Source"),
                    items: (widget.isInflow ? inflowOptions : outflowOptions)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        amountSource = newValue!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a source' : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      btn('7'),
                      btn('8'),
                      btn('9'),
                      btnAC(),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        btn('4'),
                        btn('5'),
                        btn('6'),
                        btnClear(),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      btn('1'),
                      btn('2'),
                      btn('3'),
                      btn('0'),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  widget.isInflow
                      ? PrimaryButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          buttonText: "ADD",
                          onTap: _saveExpense,
                        )
                      : PrimaryButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          buttonText: "Deduct",
                          onTap: _saveExpense,
                          isInflow: false,
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget btn(btnText) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            textControllerInput.text = textControllerInput.text + btnText;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: ColorStyles.background,
          padding: const EdgeInsets.all(18.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            btnText,
            style: TextStyles.humongous,
          ),
        ),
      ),
    );
  }

  Widget btnClear() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextButton(
        onPressed: () {
          textControllerInput.text = (textControllerInput.text.isNotEmpty)
              ? (textControllerInput.text
                  .substring(0, textControllerInput.text.length - 1))
              : "";
        },
        style: TextButton.styleFrom(
          backgroundColor: ColorStyles.background,
          padding: const EdgeInsets.all(18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: const Icon(Icons.backspace,
                size: 24.0, color: ColorStyles.gray)),
      ),
    );
  }

  Widget btnAC() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            textControllerInput.text = "";
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: ColorStyles.background,
          padding: const EdgeInsets.all(18.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Icon(
              Icons.refresh,
              size: 24.0,
              color: ColorStyles.red.withOpacity(0.8),
            )),
      ),
    );
  }
}
