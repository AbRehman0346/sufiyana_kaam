import 'package:flutter/material.dart';

class XDropdown extends StatefulWidget {
  final List<String> _items;
  String _selectedItem;
  final void Function(String? value)? _onChanged;
  final Color? _dropdownColor;
  final Color? _textColor;
  final Color? _iconColor;
  final bool _isExpanded;
  final bool _isDense;
  final bool _bold;
  final EdgeInsetsGeometry? _padding;
  XDropdown({
    super.key,
    required List<String> items,
    required String selectedItem,
    void Function(String?)? onChanged,
    Color? dropdownColor,
    Color? textColor,
    bool isExpanded = false,
    bool isDense = false,
    bool bold = false,
    Color? iconColor,
    EdgeInsetsGeometry? padding,

  }) :
        _onChanged = onChanged,
        _selectedItem = selectedItem,
        _items = items,
        _dropdownColor = dropdownColor,
        _isExpanded = isExpanded,
        _textColor = textColor,
        _isDense = isDense,
        _bold = bold,
        _iconColor = iconColor,
        _padding = padding;
  @override
  State<XDropdown> createState() => _XDropdownState();
}

class _XDropdownState extends State<XDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      padding: widget._padding,
      isDense: widget._isDense,
      isExpanded: widget._isExpanded,
      dropdownColor: widget._dropdownColor,
      value: widget._selectedItem,
      iconEnabledColor: widget._iconColor,
      iconDisabledColor: widget._iconColor,
      hint: const Text("Select a number"),
      items: List.generate(widget._items.length, (index) {
        return DropdownMenuItem(
          value: widget._items[index],
          child: Text(
            widget._items[index],
            style: TextStyle(
              color: widget._textColor,
              fontWeight: widget._bold ? FontWeight.bold : null,
            ),
          ),
        );
      }),
      onChanged: (value){
        setState(() {
          widget._selectedItem = value!;
        });
        if (widget._onChanged != null) {
          widget._onChanged!(value);
        }
      },
    );
  }
}