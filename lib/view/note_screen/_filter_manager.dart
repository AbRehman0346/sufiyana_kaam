import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/process-task.dart';
import '../../models/process.dart';
import '../../xutils/XDateTime.dart';
import '../../xutils/widgets/xdropdown.dart';

class NoteScreenFilterManager{
  final _types = _FilterTypes();
  late _AppliedFilter _appliedFilter;
  bool get isFilterApplied => _types.noFilter != _appliedFilter.filterType;

  NoteScreenFilterManager(){
    _appliedFilter = _AppliedFilter(
      filterType: _types.noFilter,
      filterValue: null,
    );
  }

  IconData getFilterIcon() {
    if (isFilterApplied) {
      return Icons.filter_alt;
    } else {
      return Icons.filter_alt_outlined;
    }
  }


  List<ProcessTask> _applyDateFilter(
      List<ProcessTask> tasks, String filterType, DateTime selectedDate) {
    if (filterType == _types.today) {
      tasks.retainWhere((task) => task.date.isToday());
    } else if (filterType == _types.specificDate) {
      tasks.retainWhere((task) => task.date.isSameDayAs(selectedDate));
    }

    return tasks;
  }

  List<ProcessTask> applyFilters(List<ProcessTask> tasks) {
    if (_appliedFilter.filterType == _types.noFilter) {
      return tasks; // No filter applied, return all tasks
    }

    List<ProcessTask> filteredTasks = List.from(tasks);

    // Apply date filter
    if (_appliedFilter.filterType == _types.today || _appliedFilter.filterType == _types.specificDate) {
      DateTime selectedDate = _appliedFilter.filterValue as DateTime;
      filteredTasks = _applyDateFilter(filteredTasks, _appliedFilter.filterType, selectedDate);
    }

    // Apply status filter
    if (_appliedFilter.filterType == _types.status) {
      String status = _appliedFilter.filterValue as String;
      filteredTasks.retainWhere((task) => task.status.isSameAs(status));
    }

    // Apply priority filter
    if (_appliedFilter.filterType == _types.priority) {
      String priority = _appliedFilter.filterValue as String;
      filteredTasks.retainWhere((task) => task.getPriorityValue == priority);
    }

    return filteredTasks;

  }

  void showFilterDialog(
      BuildContext context,
      {
        Function? onFilterApplied
      }){

    DateTime? selectedDate;
    String status = ProcessTaskStatus.pending;
    String filterOption = _types.noFilter; // Default filter option
    String priority = Priority.getValue(Priority().normal);

    if(_appliedFilter.filterType == _types.noFilter){
      filterOption = _types.noFilter;
    } else if(_appliedFilter.filterType == _types.today){
      filterOption = _types.today;
      selectedDate = _appliedFilter.filterValue as DateTime?;
    } else if(_appliedFilter.filterType == _types.specificDate){
      filterOption = _types.specificDate;
      selectedDate = _appliedFilter.filterValue as DateTime?;
    } else if(_appliedFilter.filterType == _types.status){
      filterOption = _types.status;
      status = _appliedFilter.filterValue as String;
    } else if(_appliedFilter.filterType == _types.priority){
      filterOption = _types.priority;
      priority = _appliedFilter.filterValue as String;
    } else {
      Fluttertoast.showToast(msg: "Couldn't figure out applied Filter");
      filterOption = _types.noFilter; // Reset to no filter if unknown
    }


    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Filter Tasks"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text("No Filter"),
                  value: _types.noFilter,
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                      selectedDate = null; // Reset selected date
                    });
                  },
                ),

                RadioListTile<String>(
                  title: Text("Today"),
                  value: _types.today,
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                      selectedDate = DateTime.now();
                    });
                  },
                ),

                RadioListTile<String>(
                  title: Text("Specific Date"),
                  value: _types.specificDate,
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                    });
                  },
                ),

                // Select Date Button...
                if (filterOption == _types.specificDate)
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await XDateTime().selectDate(context);
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? "Select Date"
                          : "Selected: ${XDateTime().toDateString(selectedDate!)}",
                    ),
                  ),

                RadioListTile<String>(
                  title: Text("Status"),
                  value: _types.status,
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                    });
                  },
                ),

                if(filterOption == _types.status)
                  Align(
                    alignment: Alignment.centerRight,
                    child: XDropdown(
                      items: ProcessTaskStatus.all,
                      selectedItem: status,
                      onChanged: (String? value){
                        status = value!;
                      },
                    ),
                  ),

                RadioListTile<String>(
                  title: Text("Priority"),
                  value: _types.priority,
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value!;
                    });
                  },
                ),

                if(filterOption == _types.priority)
                  Align(
                    alignment: Alignment.centerRight,
                    child: XDropdown(
                      items: Priority.all,
                      selectedItem: priority,
                      onChanged: (String? value){
                        priority = value!;
                      },
                    ),
                  ),


              ],
            );
          },
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without applying filter
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if(filterOption == _types.noFilter){
                _appliedFilter = _AppliedFilter(filterType: filterOption, filterValue: null);
              } else if (filterOption == _types.specificDate || filterOption == _types.today) {
                if(selectedDate == null) {
                  Fluttertoast.showToast(
                    msg: "Please select a date",
                  );
                  return; // Don't apply filter if no date is selected
                }
                _appliedFilter = _AppliedFilter(filterType: filterOption, filterValue: selectedDate);
              }else if (filterOption == _types.status) {
                _appliedFilter = _AppliedFilter(filterType: filterOption, filterValue: status);
              } else if (filterOption == _types.priority) {
                _appliedFilter = _AppliedFilter(filterType: filterOption, filterValue: priority);
              }

              if(onFilterApplied != null) {
                onFilterApplied();
              }

              Navigator.of(context).pop(); // Close dialog after applying filter
            },
            child: Text("Apply"),
          ),
        ],
      );
    },
    );
  }
}

class _FilterTypes{
  String noFilter = "no_filter";
  String today = "today";
  String specificDate = "specific_date";
  String status = "status";
  String priority = "priority";
}

class _AppliedFilter{
  String filterType;
  dynamic filterValue;

  _AppliedFilter({
    required this.filterType,
    this.filterValue,
  });
}