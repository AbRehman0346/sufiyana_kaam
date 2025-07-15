import 'package:flutter/material.dart';
import 'xtext.dart';

class XButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color bgColor;
  final Color textColor;
  final bool bold;
  GestureTapCallback? onPressed;
  XButton({
    super.key,
    required this.text,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize,
    this.bold = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
