import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/styles/text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final Icon icon;
  final bool? isInflow;

  const PrimaryButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.icon,
    this.isInflow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // VoidCallback (no parameters, returns void)
      borderRadius: BorderRadius.circular(6.0),
      splashColor: ColorStyles.primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: isInflow == false ? Colors.red : ColorStyles.primaryAccent,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                buttonText,
                style: TextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
