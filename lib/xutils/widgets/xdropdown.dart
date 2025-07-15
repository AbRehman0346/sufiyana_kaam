import 'package:flutter/material.dart';

class XDropdown extends StatefulWidget {
  final List<String> _items;
  String _selectedItem;
  final void Function(String? value)? _onChanged;
  final Color? _dropdownColor;
  final Color? _textColor;
  final bool _isExpanded;
  XDropdown({
    super.key,
    required List<String> items,
    required String selectedItem,
    void Function(String?)? onChanged,
    Color? dropdownColor,
    Color? textColor,
    bool isExpanded = false,
  }) :
        _onChanged = onChanged,
        _selectedItem = selectedItem,
        _items = items,
        _dropdownColor = dropdownColor,
        _isExpanded = isExpanded,
        _textColor = textColor;
  @override
  State<XDropdown> createState() => _XDropdownState();
}

class _XDropdownState extends State<XDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: widget._isExpanded,
      dropdownColor: widget._dropdownColor,
      value: widget._selectedItem,
      hint: const Text("Select a number"),
      items: List.generate(widget._items.length, (index) {
        return DropdownMenuItem(
          value: widget._items[index],
          child: Text(
            widget._items[index],
            style: TextStyle(
              color: widget._textColor,
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