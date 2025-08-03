import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';
import '../../route-generator.dart';
import '../../xutils/colors/AppColors.dart';
import '../../xutils/widgets/utils.dart';
import '../../xutils/widgets/xtext.dart';

class ReorderNotesScreen extends StatefulWidget {
  final Process process;
  Function()? onSortComplete;
  ReorderNotesScreen({super.key, required this.process, this.onSortComplete});

  @override
  State<ReorderNotesScreen> createState() => _ReorderNotesScreenState();
}

class _ReorderNotesScreenState extends State<ReorderNotesScreen> {
  bool _editMode = false;
  late List<ProcessTask> _data;


  @override
  void initState() {
    _data = widget.process.tasks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: XText(widget.process.name, bold: true, color: Colors.blue,),
        centerTitle: true,
        actions: [
          TextButton(onPressed: _sort, child: XText("Apply")),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: Utils.screenWidth,
          child: Column(
            children: [
              Utils.height(15),

              //if no data is found!...
              _data.isEmpty ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utils.height(100),
                  XText("No Data Found!", size: 20, center: true),
                ],
              ) :
              SizedBox(
                height: Utils.screenBodyHeight,
                child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      final item = _data.removeAt(oldIndex);
                      _data.insert(newIndex, item);
                    });
                  },
                  children: List.generate(
                      _data.length, (index){
                    return _buildTask(_data[index]);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTask(ProcessTask task){
    return Row(
      key: ValueKey(task.id),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: ()=>_gotoTaskView(task),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: Utils.screenWidth * 0.8,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: _getCardColor(task.status.status),
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
                task.date.date ?? "No Date",
                color: AppColors.primaryText.withValues(alpha: 0.5),
                bold: true,
                size: 10,
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: XText(
                task.status.status,
                color: AppColors.primaryText.withValues(alpha: 0.5),
                bold: true,
                size: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCardColor(String status) {
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

  void _gotoTaskView(ProcessTask task){
    Utils().showSnackBar("Touch And Hold task to reorder the tasks");
    return;
    NavigatorService.goto(Routes.ViewTask, arguments: [task, null]);
  }

  void _sort(){
    Utils.showProgressBar(msg: "Sorting tasks...");
    DatabaseServices.create().sortProcessTasks(_data);
    Utils.showToast("Tasks Sorted Successfully!");
    Navigator.pop(context);

    if(widget.onSortComplete != null){
      widget.onSortComplete!();
    }

    Navigator.pop(context);
  }

}
