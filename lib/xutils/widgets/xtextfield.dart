import 'package:flutter/material.dart';

class XTextField extends StatelessWidget {
  int _maxLines;
  final int _minLines;
  final String? _hint;
  final String? _label;
  final Color _borderColor;
  final Color? _fillColor;
  final Color? _textColor;
  final Color? _hintTextColor;
  final double _borderWidth;
  final double _borderRadius;
  final double _fontSize;
  final double _horizontalContentPadding;
  final double _verticalContentPadding;
  final bool _obscureText;
  final bool _enableSuggestions;
  final bool _autocorrect;
  final bool _filled;
  final bool _enabled;
  final bool _shadow;
  final bool _dense;
  final Widget? _suffixIcon;
  final Widget? _prefixIcon;
  final TextEditingController? _controller;
  final Function(String)? _onChange;
  final TextAlign _textAlign;
  final TextInputType? _keyboardType;
  final InputBorder? _border;
  final FocusNode? _focusNode;

  XTextField({
    super.key,
    int maxLines = 1,
    int minLines = 1,
    String? hint,
    String? label,
    Color borderColor = Colors.blue,
    Color? fillColor,
    Color? textColor,
    Color? hintTextColor,
    double borderWidth = 20,
    double borderRadius = 0,
    double fontSize = 20,
    double horizontalContentPadding = 10,
    double verticalContentPadding = 0,
    bool obscureText = false,
    bool enableSuggestions = true,
    bool autocorrect = true,
    bool filled = false,
    bool enabled = true,
    bool shadow = false,
    bool dense = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    InputBorder? border,
    TextEditingController? controller,
    // double height = 30,
    // double? width,
    Function(String)? onChange,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    TextAlign textAlign = TextAlign.start,
  })  : _controller = controller,
        _prefixIcon = prefixIcon,
        _suffixIcon = suffixIcon,
        _filled = filled,
        _enabled = enabled,
        _autocorrect = autocorrect,
        _enableSuggestions = enableSuggestions,
        _obscureText = obscureText,
        _horizontalContentPadding = horizontalContentPadding,
        _verticalContentPadding = verticalContentPadding,
        _fontSize = fontSize,
        _borderRadius = borderRadius,
        _borderWidth = borderWidth,
        _hintTextColor = hintTextColor,
        _textColor = textColor,
        _fillColor = fillColor,
        _borderColor = borderColor,
        _hint = hint,
        _shadow = shadow,
        _minLines = minLines,
        _maxLines = maxLines,
        _onChange = onChange,
        _keyboardType = keyboardType,
        _textAlign = textAlign,
        _border = border,
        _focusNode = focusNode,
        _dense = dense,
        _label = label;

  @override
  Widget build(BuildContext context) {
    if (_minLines > _maxLines) {
      _maxLines = _minLines;
    }

    InputDecoration decoration = InputDecoration(
      fillColor: _fillColor,
      filled: _filled,
      suffixIcon: _suffixIcon,
      prefixIcon: _prefixIcon,
      hintText: _hint,
      labelText: _label,
      isDense: _dense,
      hintStyle: TextStyle(color: _hintTextColor),
      contentPadding: EdgeInsets.symmetric(vertical: _verticalContentPadding, horizontal: _horizontalContentPadding),
      border: _border ?? OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: _borderColor,
          width: _borderWidth,
        ),
      ),
    );

    TextStyle textStyle = TextStyle(
        fontSize: _fontSize,
        color: _textColor,
    );
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              boxShadow: [
                BoxShadow(
                  color: _shadow ? Colors.grey.withValues(alpha: 0.5) : Colors.transparent,
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              obscureText: _obscureText,
              autocorrect: _autocorrect,
              focusNode: _focusNode,
              enabled: _enabled,
              enableSuggestions: _enableSuggestions,
              keyboardType: _keyboardType,
              textAlign: _textAlign,
              onChanged: (s) {
                if (_onChange != null) {
                  _onChange(s);
                }
              },
              maxLines: _maxLines,
              minLines: _minLines,
              decoration: decoration,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
