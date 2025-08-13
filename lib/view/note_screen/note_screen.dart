import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/res/local_store.dart';
import 'package:sufiyana_kaam/services/database/database-services.dart';
import 'package:sufiyana_kaam/view/create-task.dart';
import 'package:sufiyana_kaam/view/note_screen/_filter_manager.dart';
import 'package:sufiyana_kaam/view/note_screen/_item_selection.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';
import 'package:sufiyana_kaam/xutils/XDateTime.dart';
import 'package:sufiyana_kaam/xutils/dummy-data.dart';
import '../../route-generator.dart';
import '../../xutils/colors/AppColors.dart';
import '../../xutils/widgets/XButton.dart';
import '../../xutils/GlobalContext.dart';
import '../../xutils/widgets/utils.dart';
import '../../xutils/widgets/xdropdown.dart';
import '../../xutils/widgets/xtext.dart';
import '../../xutils/widgets/xtextfield.dart';

class NoteScreen extends StatefulWidget {
  final Process process;
  const NoteScreen({super.key, required this.process});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool _editMode = false;
  List<ProcessTask> _data = [];
  late Key _futureKey;
  final NoteScreenFilterManager _filter = NoteScreenFilterManager();
  final TextEditingController _searchController = TextEditingController();
  final NoteItemSelection _itemSelection = NoteItemSelection();
  bool _showFloatingButton = true;

  /* _isDataFoundOnDatabase: This check is used to keep the create button hidden that is used to
  create the first task in the process....After first task is created.. there is no need for this
  button and it remains hidden always.... */
  bool _isDataFoundOnDatabase = true;

  @override
  void initState() {
    _assignNewFutureKey();
    super.initState();
  }

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

        if(_isDataFoundOnDatabase){
          _isDataFoundOnDatabase = _data.isEmpty;
        }

        _data = _filter.applyFilters(_data);

        _applySearch();

        return Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: SizedBox(
              width: Utils.screenWidth,
              child: Column(
                children: [
                  Utils.height(15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: (Utils.screenWidth * 0.1)),
                    child: Row(
                      children: [
                        Expanded(
                          child: XTextField(
                            hint: "Search Tasks",
                            fillColor: Colors.white,
                            shadow: true,
                            border: InputBorder.none,
                            borderRadius: 10,
                            dense: true,
                            verticalContentPadding: 3,
                            controller: _searchController,
                            onChange: (String? value) => setState(() {}),
                          ),
                        ),
                        Utils.width(20),
                        GestureDetector(
                          onTap: () => _filter.showFilterDialog(
                              context,
                              onFilterApplied: () => setState(() {}),
                          ),
                          child: Icon(_filter.getFilterIcon(), size: 28),
                        ),
                      ],
                    ),
                  ),
                  Utils.height(15),

                  //if no data is found!...
                  _data.isEmpty ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Utils.height(100),
                      XText("No Data Found!", size: 20, center: true),
                      Utils.height(20),
                      if(_isDataFoundOnDatabase)
                      XButton(
                          text: "Create",
                          bold: true,
                          onPressed: _createTask,
                      ),
                    ],
                  ) :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_data.length, (index){
                      bool isThisLastIndex = _data.length - 1 == index;
                      return Column(
                        children: [
                          if(index == 0 && _editMode)
                            _buildArrowEdit(addTask: () => _createTask(0)),

                          _buildTask(
                              _data[index],
                              isSelected: _itemSelection.isSelected(_data[index]),
                          ),

                          if(!isThisLastIndex || _editMode)
                            _buildArrowEdit(addTask: () => _createTask(index + 1),),

                          if(isThisLastIndex)
                            Utils.height(100),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: _getFloatingActionButton(),
        );
      }
    );
  }

  PreferredSizeWidget? _buildAppBar(){
    return AppBar(
      title: XText(widget.process.name, bold: true, color: Colors.blue,),
        centerTitle: true,
      actions: [
        PopupMenuButton(
          itemBuilder: (context){
          return [
            PopupMenuItem(
              value: "sort",
              child: XText("Sort Tasks", size: 15, color: AppColors.blackText, bold: true),
            ),
          ];
        },
          onSelected: _onPopupMenuSelected,
        ),
      ],
    );
  }

  void _onPopupMenuSelected(String value){
    if(value == "sort"){
      _gotoOrderScreen();
    }
  }

  void _gotoOrderScreen(){
    widget.process.tasks = _data;
    NavigatorService.goto(Routes.reorderNotesScreen, arguments: [widget.process, (){
      _reloadAllData();
    }]);
  }

  Widget? _getFloatingActionButton(){

    if(_data.isEmpty || !_showFloatingButton){
      return null;
    }

    return SizedBox(
      width: 100,
      child: FloatingActionButton(
          child: XText(_editMode ? "Done" : "Edit", size: 15,),
          onPressed: (){
            setState(() {
              _editMode = !_editMode;
            });
          }),
    );
  }

  void _toggleSelection(ProcessTask task) {
    // For now this function is used to copy paste the task.
    // If you want to enable selection mode, just uncomment the below code.
    // and do comment: LocalStore.task = task;
    LocalStore.task = task;
    Fluttertoast.showToast(msg: "Task Copied");
    return;
    // Just enable the below code to enable selection mode.
    if(!_editMode){
      _itemSelection.toggleSelection(task);
      _showFloatingButton = !_itemSelection.hasSelection();
      setState(() {});
    }
  }

  Widget _buildTask(
      ProcessTask task,
  {
    bool isSelected = false,
  }
      ){
    return Container(
      color: isSelected ? AppColors.selectionColor : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showDetailOfTask(task),
                onLongPress: () => _toggleSelection(task),
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
          // Delete Icon
          if(_editMode)
            GestureDetector(
                onTap: () => _deleteTask(task),
                child: Icon(Icons.delete, color: AppColors.deleteColor),
            ),
        ],
      ),
    );
  }

  Widget _buildArrowEdit({
    required Function() addTask,
  }){
    if(_editMode){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Add Task.
          GestureDetector(
              onTap: () => addTask(),
              child: Icon(Icons.add, size: 50, color: AppColors.cardColor),
          ),

        ],
      );
    }
    else{
      return Icon(Icons.arrow_downward, size: 50, color: AppColors.cardColor);
    }

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

  Future<void> _deleteTask(ProcessTask task) async {
    Utils.showProgressBar();
    await DatabaseServices.create().deleteProcessTask(task.id!);
    Utils.hideProgressBar();
    _reloadAllData();
    Fluttertoast.showToast(msg: "Task Deleted...");
  }
  
  void _showDetailOfTask(ProcessTask task){
    // if Selection is enabled, toggle selection
    if(_itemSelection.hasSelection()){
      _toggleSelection(task);
      return;
    }

    if(_editMode){
      Utils().showSnackBar("Please Turn off the Edit Mode First.");
      return;
    }


    NavigatorService.goto(Routes.ViewTask, arguments: [task, (ProcessTask updatedTask) {
      _reloadAllData();
    }]);
  }

  void _createTask([int? position]) {
    Utils().showBottomSheet(
      handleScrolling: true,
      children: [
        CreateTask(
            processId: widget.process.id!,
            onTaskCreated: (ProcessTask task) async {
              if(position != null){
                _data.insert(position, task);
                await DatabaseServices.create().sortProcessTasks(_data);
              }
              _editMode = false;
              _reloadAllData();
            }
        ),
      ],
    );
  }

  void _assignNewFutureKey(){
    _futureKey = UniqueKey();
  }

  void _reloadAllData(){
    setState(() {
      _assignNewFutureKey();
    });
  }

  void _applySearch(){
    if(_searchController.text.trim() == ""){
      return;
    }
    _data.retainWhere((item) => item.title.toLowerCase().contains(_searchController.text.toLowerCase()));
  }
}

