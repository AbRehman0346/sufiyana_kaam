import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/route-generator.dart';
import 'package:sufiyana_kaam/xutils/colors/AppColors.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtext.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtextfield.dart';
import '../services/database-services.dart';
import '../xutils/NavigatorService.dart';
import '../xutils/widgets/XButton.dart';
import '../xutils/widgets/utils.dart';
import '../xutils/widgets/xdropdown.dart';

class ViewTask extends StatefulWidget {
  ProcessTask task;
  void Function(ProcessTask)? onTaskUpdated;
  ViewTask({super.key, required this.task, this.onTaskUpdated});

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  String _status = ProcessTaskStatus.pending;

  late ProcessTask task;

  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

 // default status
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: XText(task.title), centerTitle: true,
        actions: [
          TextButton(onPressed: (){
            NavigatorService.goto(Routes.editTask, arguments: [task, (ProcessTask newTask){
              setState(() {
                  task = newTask;
              });
              widget.onTaskUpdated!(newTask);
            }]);
          }, child: XText("EDIT"))
        ],
      ),
      body: SingleChildScrollView(
        child: _buildBody(task),
      ),
    );
  }

  Widget _buildBody(ProcessTask task){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //     Title...
          XText("Title:", size: 18, color: Colors.black, bold: true),
          XText(
            task.title,
            size: 20,
            // bold: true,
            textAlign: TextAlign.center,
          ),

          Utils.height(20),

          XText("Description:", size: 18, color: Colors.black, bold: true),
          XText(task.description, size: 16, color: Colors.black),

          Utils.height(20),
          _styledRow("Date:    ", task.date.date),

          Utils.height(10),
          _styledRow("Time:    ", task.time),

          Utils.height(10),
          _styledRow("Priority:", task.getPriorityValue),

          // Utils.height(10),
          // styledRow("STATUS:", task.status),

          Utils.height(10),

          SizedBox(
            width: Utils.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _styledDropdownRow(
                    heading: "STATUS: ",
                    items: ProcessTaskStatus.all,
                    selectedItem: task.status.status,
                    onChanged: (newStatus) {
                      _status = newStatus!;
                    },
                ),
                // XDropdown(
                //   items: ProcessTaskStatus.all, selectedItem: task.status,
                //   onChanged: (newStatus){
                //     status = newStatus!;
                //   },
                // ),

                Utils.height(50),

                //     Mark Completed Button...
                XButton(
                  bgColor: Colors.blue.shade300,
                  text: "Apply",
                  onPressed: (){
                    Utils.showProgressBar();
                    DatabaseServices.create().updateProcessTaskStatus(task.id!, _status).then((value) {
                      Utils.hideProgressBar();

                      if(widget.onTaskUpdated != null){
                        widget.onTaskUpdated!(task);
                      }

                      Fluttertoast.showToast(msg: "Updated...");
                      NavigatorService.pop();
                    }).catchError((error){
                      Utils.hideProgressBar();
                      Fluttertoast.showToast(msg: "Error: $error");
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _styledRow(
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

  Widget _styledDropdownRow(
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
