import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';
import '../models/process-task.dart';
import '../xutils/colors/AppColors.dart';
import '../xutils/widgets/XButton.dart';
import '../xutils/widgets/utils.dart';
import '../xutils/widgets/xdropdown.dart';
import '../xutils/widgets/xtext.dart';
import '../xutils/widgets/xtextfield.dart';

class CreateProcessTaskView extends StatefulWidget {
  int processId;
  void Function(ProcessTask process)? onTaskCreated;
  CreateProcessTaskView({
    super.key,
    required this.processId,
    this.onTaskCreated,
  });

  @override
  State<CreateProcessTaskView> createState() => _CreateProcessTaskViewState();
}

class _CreateProcessTaskViewState extends State<CreateProcessTaskView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String importance = Priority().normal;
  DateTime? _date;
  TimeOfDay? _timeOfDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Utils.screenBodyHeight,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          XText("ADD TASK", size: 25, color: AppColors.secondaryText, bold: true,),
          Utils.height(20),
          XTextField(
            controller: titleController,
            hint: "Task Title",
            borderRadius: 10,
          ),
          Utils.height(20),
          XTextField(
            controller: descriptionController,
            hint: "Task Description",
            borderRadius: 10,
            minLines: 3,
          ),

          Utils.height(20),
          // Select Date Row...
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: XText(
                  _date != null
                      ? Utils().toStringDate(_date!)
                      :
                  "                          ",
                  color: Colors.white,
                  bold: true,
                  size: 16,
                ),
              ),
              Utils.width(20),
              GestureDetector(
                onTap: () async {
                  _date = await Utils().selectDate(context);
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: XText("Select Date", color: Colors.white, bold: true),
                ),
              ),
            ],
          ),

          Utils.height(20),
          // Select Time Row...
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: XText(
                  _timeOfDay != null
                      ? Utils().toStringTime(_timeOfDay!)
                      :
                  "                          ",
                  color: Colors.white,
                  bold: true,
                  size: 16,
                ),
              ),
              Utils.width(20),
              GestureDetector(
                onTap: () async {
                  _timeOfDay = await Utils().selectTime(context);
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: XText("Select Time", color: Colors.white, bold: true),
                ),
              ),
            ],
          ),
          Utils.height(20),
          SizedBox(
            width: Utils.screenWidth * 0.6,
            child: XDropdown(
              items: Priority().all,
              selectedItem: Priority().normal,
              isExpanded: true,
              onChanged: (text){
                importance = text!;
              },
            ),
          ),

          Utils.height(40),
          //   Add Button Row...
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              XButton(
                  text: "ADD TASK",
                onPressed: () async => addTask(),
              ),
            ],
          ),
          Utils.height(80),
        ],
      ),
    );
  }

  Future<void> addTask() async {
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();
    String? date = _date != null
        ? "${Utils().getMonthName(_date!.month)} ${_date!.day}, ${_date!.year}"
        : null;
    String? time = _timeOfDay != null
        ? "${_timeOfDay!.hour}:${_timeOfDay!.minute.toString().padLeft(2, '0')}"
        : null;
    if(title.isEmpty){
      Utils.showToast("Name is Mandatory");
      return;
    }

    Utils.showProgressBar();

    int count = await DatabaseServices.create().getProcessTaskCount(widget.processId);

    ProcessTask task = ProcessTask(
      title: title,
      description: desc,
      date: date,
      time: time,
      order: count+1,
      priority: importance,
      processId: widget.processId,
      status: ProcessTaskStatus.pending,
    );

    int id = await DatabaseServices.create().insertProcessTask(task);

    task.id = id;

    widget.onTaskCreated?.call(task);
    Utils.hideProgressBar();
    Utils.showToast("Task Added Successfully");
    Navigator.pop(GlobalContext.getContext);
  }
}
