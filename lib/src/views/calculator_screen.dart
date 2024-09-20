import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:expense_tracker/widgets/buttons.dart';
import 'package:expense_tracker/widgets/form_components.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String amount = "";
  String amountSource = "";
  final textControllerInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textControllerInput.addListener(() {});
  }

  @override
  void dispose() {
    textControllerInput.dispose();
    super.dispose();
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
                            color: ColorStyles.lightGreen.withOpacity(0.2),
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
                  child: FormTextField(
                    hintText: "Select Source",
                    inputType: TextInputType.text,
                    onSave: (String value) {
                      amountSource = value;
                    },
                    onFocus: () {
                      //todo: yet to decide
                    },
                    validator: (String value) {
                      return ((value.isEmpty)) ? "Enter source" : null;
                    },
                    trailing: const Icon(
                      Icons.arrow_drop_down,
                      color: ColorStyles.gray,
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
                  PrimaryButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    buttonText: "ADD",
                    onTap: () {
                      //check if the source is entered
                      // if (_formKey.currentState.validate()) {
                      //   //trigger the onSave callback of all the formfield in this key
                      //   _formKey.currentState.save();
                      // }
                    },
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
          splashFactory: InkRipple.splashFactory,
          // primary: ColorStyles.primaryAccent,
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
          splashFactory: InkRipple.splashFactory,
          // primary: ColorStyles.red.withOpacity(0.6),
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
          splashFactory: InkRipple.splashFactory,
          // primary: ColorStyles.red.withOpacity(0.6),
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
