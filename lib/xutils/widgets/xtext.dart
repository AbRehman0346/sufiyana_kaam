import 'package:flutter/material.dart';

class XText extends StatelessWidget {
  final double? size;
  final String text;
  final Color? color;
  FontWeight? weight;
  final bool lineThrough;
  final bool bold;
  final bool halfBold;
  final bool center;
  final int? maxLines;
  final TextOverflow? overflow;
  TextAlign? textAlign;
  final String? fontFamily;
  final double? letterSpacing;
  XText(
      this.text,
      {
        Key? key,
        this.size,
        this.color,
        this.weight,
        this.lineThrough = false,
        this.bold = false,
        this.halfBold = false,
        this.maxLines,
        this.overflow,
        this.textAlign,
        this.fontFamily,
        this.letterSpacing,
        this.center = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(textAlign == null && center){
      textAlign = TextAlign.center;
    }

    if(weight == null){
      if(bold){
        weight = FontWeight.bold;
      }else if(halfBold){
        weight = FontWeight.w600;
      }
    }
    return Text(text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size, color: color, fontWeight: weight,
        decoration: lineThrough ? TextDecoration.lineThrough : null,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
      ),
    );
  }
}