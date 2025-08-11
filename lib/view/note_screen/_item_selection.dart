import 'package:sufiyana_kaam/models/process-task.dart';

class NoteItemSelection {
  final List<ProcessTask> _selectedItems = [];

  List<ProcessTask> get selectedItems => _selectedItems;

  bool isSelected(ProcessTask item) {
    return _selectedItems.any((selectedItem) => selectedItem.id == item.id);
  }

  bool hasSelection() {
    return _selectedItems.isNotEmpty;
  }

  void toggleSelection(ProcessTask item) {
    if (isSelected(item)) {
      _selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
    } else {
      _selectedItems.add(item);
    }
  }

  void clearSelection() {
    _selectedItems.clear();
  }

  int get selectedCount => _selectedItems.length;
}