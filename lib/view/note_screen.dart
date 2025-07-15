import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/view/create-process-task-view.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';
import 'package:sufiyana_kaam/xutils/dummy-data.dart';
import '../route-generator.dart';
import '../xutils/colors/AppColors.dart';
import '../xutils/widgets/XButton.dart';
import '../xutils/GlobalContext.dart';
import '../xutils/widgets/utils.dart';
import '../xutils/widgets/xdropdown.dart';
import '../xutils/widgets/xtext.dart';
import '../xutils/widgets/xtextfield.dart';

class NoteScreen extends StatefulWidget {
  final Process process;
  const NoteScreen({super.key, required this.process});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool editMode = false;
  List<ProcessTask> _data = [];
  Key _futureKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: _futureKey,
      future: DatabaseServices.create().fetchProcessTasks(widget.process.id!),
      builder: (context, AsyncSnapshot snap) {

        if(!snap.hasData){
          return Scaffold(
            appBar: _buildAppBar(),
            body: SizedBox(
              height: Utils.screenBodyHeight,
              child: Center(
                  child: CircularProgressIndicator()
              ),
            ),
          );
        }

        _data = snap.data;

        if(_data.isEmpty){
          return Scaffold(
            appBar: _buildAppBar(),
            body: SizedBox(
              width: Utils.screenWidth,
              height: Utils.screenBodyHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  XText("No Data Found!\nTry Adding a Task", size: 20, center: true),
                  Utils.height(20),
                  XButton(
                      text: "CREATE TASK",
                    onPressed: _showCreateTaskBottomSheet,
                  )
                ],
              ),
            ),
          );
        }


        return Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: SizedBox(
              width: Utils.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_data.length, (index){
                  bool isThisLastIndex = _data.length - 1 == index;
                  return Column(
                    children: [
                      if(index == 0 && editMode)
                        _buildArrowEdit(editModeFunction: () => _showCreateTaskBottomSheet(0)),

                      _buildTask(_data[index]),

                      if(!isThisLastIndex || editMode)
                        _buildArrowEdit(
                          editModeFunction: () => _showCreateTaskBottomSheet(index + 1),
                        ),

                      if(isThisLastIndex)
                        Utils.height(100),
                    ],
                  );
                }),
              ),
            ),
          ),
          floatingActionButton: _getFloatingActionButton(),
        );
      }
    );
  }

  PreferredSizeWidget? _buildAppBar(){
    return AppBar(title: XText(widget.process.name, bold: true, color: Colors.blue,), centerTitle: true);
  }

  Widget? _getFloatingActionButton(){

    if(_data.isEmpty){
      return null;
    }

    return SizedBox(
      width: 100,
      child: FloatingActionButton(
          child: XText(editMode ? "Done" : "Edit", size: 15,),
          onPressed: (){
            setState(() {
              editMode = !editMode;
            });
          }),
    );
  }

  Widget _buildTask(ProcessTask task){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: ()=>_showDetailOfTask(task),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: Utils.screenWidth * 0.8,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: getCardColor(task.status),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: XText(
                        task.title,
                        size: 18,
                        color: AppColors.primaryText,
                        bold: true,
                      textAlign: TextAlign.center,
                    ),
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 10,
              child: XText(
                  task.date ?? "No Date",
                  color: AppColors.primaryText.withValues(alpha: 0.5),
                  bold: true,
                  size: 10,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: XText(
                task.status,
                color: AppColors.primaryText.withValues(alpha: 0.5),
                bold: true,
                size: 10,
              ),
            ),
          ],
        ),
        if(editMode)
          GestureDetector(
              onTap: () => _deleteTask(task),
              child: Icon(Icons.delete, color: AppColors.deleteColor),
          ),
      ],
    );
  }

  Color getCardColor(String status) {
    switch (status) {
      case ProcessTaskStatus.completed:
        return AppColors.taskCompletedCardColor;
      case ProcessTaskStatus.inProgress:
        return AppColors.cardColor;
      case ProcessTaskStatus.pending:
        return Colors.orange;
      case ProcessTaskStatus.cancelled:
        return Colors.grey;
      default:
        return AppColors.cardColor;
    }
  }

  Future<void> _deleteTask(ProcessTask task) async {
    Utils.showProgressBar();
    await DatabaseServices.create().deleteProcessTask(task.id!);
    Utils.hideProgressBar();
    setState(() {
      _futureKey = UniqueKey(); // to refresh the future builder
    });
    Fluttertoast.showToast(msg: "Task Deleted...");
  }
  
  void _showDetailOfTask(ProcessTask task){

    Widget dateTimeRow(String heading, String? value){
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
            child: XText(
              value ?? "                  ",
              color: Colors.white,
              bold: true,
              size: 16,
            ),
          ),
        ],
      );
    }

    String status = task.status;

    // shows a bottom sheet containing the detail of task.
      Utils().showBottomSheet(
        handleScrolling: true,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.height(50),
            //     Title...
            Center(
              child: XText(
                task.title,
                size: 20,
                bold: true,
                textAlign: TextAlign.center,
              ),
            ),

            Utils.height(20),

            XText("Description:", size: 18, color: Colors.black, bold: true),
            XText(task.description, size: 16, color: Colors.black),

            Utils.height(20),
            dateTimeRow("Date:    ", task.date),

            Utils.height(10),
            dateTimeRow("Time:    ", task.time),

            Utils.height(10),
            dateTimeRow("Priority:", task.priority),

            Utils.height(10),
            dateTimeRow("STATUS:", task.status),

            Utils.height(50),

            SizedBox(
              width: Utils.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  XDropdown(
                    items: ProcessTaskStatus.all, selectedItem: task.status,
                    onChanged: (newStatus){
                      status = newStatus!;
                    },
                  ),

                  Utils.height(10),

                  //     Mark Completed Button...
                  XButton(
                    bgColor: Colors.grey.shade500,
                    text: "Apply",
                    onPressed: (){
                      Utils.showProgressBar();
                      DatabaseServices.create().updateProcessTaskStatus(task.id!, status).then((value) {
                        Utils.hideProgressBar();
                        setState(() {
                          _futureKey = UniqueKey(); // refresh the future builder
                        });
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
      ]);

  }

  Widget _buildArrowEdit({
    Function()? editModeFunction,
  }){
    if(editMode){
      return GestureDetector(
        onTap: editModeFunction,
          child: Icon(Icons.add, size: 50, color: AppColors.cardColor));
    }
    else{
      return Icon(Icons.arrow_downward, size: 50, color: AppColors.cardColor);
    }

  }

  void _showCreateTaskBottomSheet([int? position]) {
    Utils().showBottomSheet(
      handleScrolling: true,
      children: [
        CreateProcessTaskView(
            processId: widget.process.id!,
            onTaskCreated: (ProcessTask task) async {
              if(position != null){
                _data.insert(position, task);
                await DatabaseServices.create().sortProcessTasks(_data);
              }
              setState(() {_futureKey = UniqueKey();}); // refresh the future builder
            }
        ),
      ],
    );
  }
}
