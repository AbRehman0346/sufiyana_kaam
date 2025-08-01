import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';
import '../models/process.dart';
import '../services/database-services.dart';
import '../xutils/XDateTime.dart';
import '../xutils/colors/AppColors.dart';
import '../xutils/widgets/XButton.dart';
import '../xutils/widgets/utils.dart';
import '../xutils/widgets/xdropdown.dart';
import '../xutils/widgets/xtext.dart';
import '../xutils/widgets/xtextfield.dart';

class EditTask extends StatefulWidget {
  ProcessTask task;
  void Function(ProcessTask)? onTaskUpdated;
  EditTask({super.key, required this.task, this.onTaskUpdated});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  ProcessTask get task => widget.task;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? date;
  String? time;
  late int priority;
  late String status;


  @override
  void initState() {
    titleController = TextEditingController(text: task.title);
    descriptionController = TextEditingController(text: task.description);
    date = task.date.date ?? "                      ";
    time = task.time ?? "                      ";
    priority = task.priority;
    status = task.status.status;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: XText(widget.task.title), centerTitle: true,
        actions: [
          TextButton(onPressed: exitEditMode, child: XText("Exit"))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //     Title...
              XText("Title:", size: 18, color: Colors.black, bold: true),
              XTextField(
                controller: titleController,
              ),

              Utils.height(20),

              XText("Description:", size: 18, color: Colors.black, bold: true),
              XTextField(
                controller: descriptionController,
                minLines: 3,
                maxLines: 3,
              ),

              Utils.height(20),
              styledRow(
                  "Date:        ",
                  date,
                  onPressed: selectDate
              ),

              Utils.height(10),



              Utils.height(10),
              styledRow(
                "Time:        ",
                time,
                onPressed: selectTime,
              ),

              Utils.height(10),
              styledDropdownRow(
                heading: "PRIORITY:",
                items: Priority.all,
                selectedItem: Priority.getValue(priority),
                onChanged: (newPriority) => priority = Priority.getPriority(newPriority!),
              ),

              Utils.height(10),
              styledDropdownRow(
                heading: "STATUS:   ",
                items: ProcessTaskStatus.all,
                selectedItem: status,
                onChanged: (newStatus) => status = newStatus!,
              ),

              Utils.height(50),

              SizedBox(
                width: Utils.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //     Mark Completed Button...
                    XButton(
                      bgColor: Colors.blue.shade300,
                      text: "Apply",
                      onPressed: applyButtonOnPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void exitEditMode() {
    NavigatorService.pop();
  }

  Future<void> selectDate() async {
    DateTime? datetime = await XDateTime().selectDate(context);
    if(datetime != null){
      setState(() {
        date = XDateTime().toDateString(datetime);
      });
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? timeOfDay = await XDateTime().selectTime(context);
    if(timeOfDay != null){
      setState(() {
        time = XDateTime().toTimeString(timeOfDay);
      });
    }
  }

  Future<void> applyButtonOnPressed() async {
    String title = titleController.text.trim();
    String desc = descriptionController.text.trim();

    if(title.isEmpty){
      Fluttertoast.showToast(msg: "Please enter a title");
      return;
    }


    ProcessTask updatedTask = ProcessTask(
      id: task.id,
      title: title,
      description: desc,
      date: date,
      time: time,
      priority: priority,
      status: status,
      order: task.order,
      processId: task.processId,
    );



    Utils.showProgressBar();
    await DatabaseServices.create().updateTask(updatedTask).then((value) {
      Utils.hideProgressBar();
      Fluttertoast.showToast(msg: "Updated Successfully");
      if(widget.onTaskUpdated != null){
        widget.onTaskUpdated!(updatedTask);
      }
      NavigatorService.pop();
    }).catchError((error){
      Utils.hideProgressBar();
      log("Error updating task: $error");
      Fluttertoast.showToast(msg: "Error: $error");
    });
  }

  Widget styledRow(
      String heading,
      String? value,
      {
        void Function()? onPressed,
      }
      ){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
          child: XText(heading, color: Colors.white, bold: true, size: 16,),
        ),
        // Utils.width(20),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: XText(
              value ?? "                  ",
              color: Colors.white,
              bold: true,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget styledDropdownRow(
      {
        required String heading,
        required List<String> items,
        required String selectedItem,
        void Function(String?)? onChanged,
      }
      ){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
          child: XText(heading, color: Colors.white, bold: true, size: 16,),
        ),
        // Utils.width(20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
          ),
          child: XDropdown(
            items: items,
            selectedItem: selectedItem,
            isDense: true,
            textColor: AppColors.primaryText,
            bold: true,
            dropdownColor: Colors.green,
            iconColor: AppColors.primaryText,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
