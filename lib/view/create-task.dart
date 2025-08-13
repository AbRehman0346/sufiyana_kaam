import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/res/local_store.dart';
import 'package:sufiyana_kaam/services/database/database-services.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';
import 'package:sufiyana_kaam/xutils/XDateTime.dart';
import '../models/process-task.dart';
import '../xutils/colors/AppColors.dart';
import '../xutils/widgets/XButton.dart';
import '../xutils/widgets/utils.dart';
import '../xutils/widgets/xdropdown.dart';
import '../xutils/widgets/xtext.dart';
import '../xutils/widgets/xtextfield.dart';

class CreateTask extends StatefulWidget {
  int processId;
  void Function(ProcessTask process)? onTaskCreated;
  CreateTask({
    super.key,
    required this.processId,
    this.onTaskCreated,
  });

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int importance = Priority().normal;
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
          Row(
            mainAxisAlignment: LocalStore.task == null ? MainAxisAlignment.center :
              MainAxisAlignment.spaceBetween,
            children: [
              XText("ADD TASK", size: 25, color: AppColors.secondaryText, bold: true,),
              if(LocalStore.task != null)
                TextButton(onPressed: goPasteOperation, child: XText("Paste")),
            ],
          ),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: XText(
                    _date != null
                        ? XDateTime().toDateString(_date!)
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
                    _date = await XDateTime().selectDate(context);
                    FocusManager.instance.primaryFocus?.unfocus();
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
          ),

          Utils.height(20),
          // Select Time Row...
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: XText(
                    _timeOfDay != null
                        ? XDateTime().toTimeString(_timeOfDay!)
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
                    _timeOfDay = await XDateTime().selectTime(context);
                    FocusManager.instance.primaryFocus?.unfocus();
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
          ),
          Utils.height(20),
          SizedBox(
            width: Utils.screenWidth * 0.6,
            child: XDropdown(
              items: Priority.all,
              selectedItem: Priority.getValue(Priority().normal),
              isExpanded: true,
              onChanged: (text){
                importance = Priority.getPriority(text!);
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

  void goPasteOperation(){
    if(LocalStore.task == null) {
      Utils().showSnackBar("Nothing is Copied.");
      return;
    };
    titleController.text = LocalStore.task!.title;
    descriptionController.text = LocalStore.task!.description;
    _date = LocalStore.task!.date.toDateTime();

    if(LocalStore.task!.time != null){
      _timeOfDay = XDateTime().toTimeOfDay(LocalStore.task!.time!);
    }
    importance = LocalStore.task!.priority;
    Utils.showToast("Pasted!");
    LocalStore.task = null;
    FocusManager.instance.primaryFocus?.unfocus();
    // Refresh the screen to show the pasted data
    setState(() {});

  }

  Future<void> addTask() async {
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();
    String? date = _date != null
        ? XDateTime().toDateString(_date!)
        : null;
    String? time = _timeOfDay != null
        ? XDateTime().toTimeString(_timeOfDay!)
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

    task = await DatabaseServices.create().insertProcessTask(task);

    widget.onTaskCreated?.call(task);
    Utils.hideProgressBar();
    Utils.showToast("Task Added Successfully");
    Navigator.pop(GlobalContext.getContext);
  }
}
