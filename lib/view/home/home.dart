import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sufiyana_kaam/models/online-version.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/route-generator.dart';
import 'package:sufiyana_kaam/services/database/database-services.dart';
import 'package:sufiyana_kaam/view/home/create-process.dart';
import 'package:sufiyana_kaam/view/create-task.dart';
import 'package:sufiyana_kaam/view/udpate_app/version-update-dialog.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';
import 'package:sufiyana_kaam/xutils/colors/AppColors.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtext.dart';
import '../../services/version/version.dart';
import '../../xutils/widgets/utils.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Key _futureKey = UniqueKey();

  void gotoBackupView() {
    NavigatorService.goto(Routes.backupView);
  }

  void gotoPrivacyPolicy() {
    NavigatorService.goto(Routes.privacyPolicy);
  }

  void _handlePrivacyPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    bool isAccepted = prefs.getBool('privacy_policy_accepted') ?? false;

    if (!isAccepted) {
      Utils().showPrivacyPolicyDialog();
    }
  }

  void _initApp(){
    Version().init();
    _handlePrivacyPolicy();
  }

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Processes',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          PopupMenuButton(
            color: AppColors.backgroundPrimary,
              iconColor: AppColors.primaryText,
              itemBuilder: (context) => [
            PopupMenuItem(onTap: gotoBackupView,child: XText("Backup Database")),
            PopupMenuItem(onTap: gotoPrivacyPolicy,child: XText("Privacy Policy")),
            PopupMenuItem(onTap: _checkVersion,child: XText("Check Version")),
          ]),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Cards
              Expanded(
                child: FutureBuilder(
                  key: _futureKey,
                  future: DatabaseServices.create().fetchProcesses(),
                  builder: (context, AsyncSnapshot snap){
                    if(!snap.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<Map> processes = snap.data;
                    if(processes.isEmpty){
                      return Center(
                        child: XText("No processes found", size: 18, color: Colors.grey),
                      );
                    }

                    return ListView(
                      children: List.generate(processes.length, (index){
                        var process = Process.fromMap(processes[index]);
                        return _ProjectCard(
                          process: process,
                          setState: () => setState(() {
                            _futureKey = UniqueKey(); // Refresh the FutureBuilder
                          }),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
            onPressed: _showCreateProcessForm,
          child: XText("CREATE", color: Colors.white, size: 16, bold: true),
        ),
      ),
    );
  }

  void _showCreateProcessForm(){
    showDialog(context: GlobalContext.getContext, builder: (context){
      return SimpleDialog(
        children: [
          CreateProcess(
            onProcessCreated: (wasCreated) {
              if(wasCreated) {
                // Optionally, you can refresh the home screen or show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Process created successfully!")),
                );
              }
              Navigator.of(context).pop(); // Close the dialog after creation
              setState(() {
                _futureKey = UniqueKey(); // Refresh the FutureBuilder
              });
            },
          ),
        ],
      );
    });
  }

  Future<void> _checkVersion() async {
    Utils.showProgressBar();
    VersionModel model = await Version().checkAppVersion();
    Utils.hideProgressBar();

    if(model.isLatest){
      Utils().showOKDialog("About", "App is at it's Latest Version");
    }else{
      Version().actionOnVersion(model);
    }
  }
}

class _ProjectCard extends StatelessWidget {
  final Process process;
  final Function()? setState;
  const _ProjectCard({
    super.key,
    required this.process,
    this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _gotoNoteScreen(process),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: _getPriorityGradient(process.priority),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            // TODO: Options Button Here..Commented out for now
            Positioned(
              top: 0,
              left: 0,
              child: PopupMenuButton(
                color: AppColors.backgroundPrimary,
                  child: Icon(Icons.more_horiz, color: Colors.white),
                  itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Process'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Process'),
                  ),
                ];
              }, onSelected: (value) {
                if(value == 'edit'){
                  void onEdited(bool isEdited){
                    Navigator.pop(context);
                    Utils.showToast("UPDATED SUCCESSFULLY");
                    if(setState != null){
                      setState!();
                    }
                  }
                  NavigatorService.goto(Routes.editProcess, arguments: [process, onEdited]);
                } else if(value == 'delete'){
                  Utils().showTwoButtonDialog(
                    title: "Delete Process",
                    message: "Are you sure you want to delete this process?",
                    onYes: () async {
                      if(process.id == null){
                        Utils.showToast("Error: Can't Find Process Id");
                        return;
                      }
                      Utils.showProgressBar(msg: "Deleting Process...");
                      await DatabaseServices.create().deleteProcess(process.id!);
                      Utils.showToast("Process deleted successfully");
                      NavigatorService.pop();  // Close the Progress Dialog
                      NavigatorService.pop(); //Close the Dialog
                      if(setState != null) {
                        setState!(); // Refresh the Home Screen
                      }
                    },
                  );
                }
              }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.height(25),
                Text(
                  process.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                FutureBuilder(
                  future: DatabaseServices.create().fetchProcessTasks(process.id!),
                  builder: (context, AsyncSnapshot snap) {
                    if(!snap.hasData){
                      return XText("Loading...", color: Colors.white70, size: 16);
                    }

                    List<ProcessTask> tasks = snap.data;
                    int completed = 0;
                    int total = tasks.length;

                    for(int i=0; i<tasks.length; i++){
                      if(tasks[i].status.isCompleted){
                        completed++;
                      }
                    }

                    return Text(
                      '$completed/$total tasks',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    );
                  }
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _addTaskToProcess(process.id),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white38,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTaskToProcess(int? processId) {

    if(processId == null){
      Utils().showSnackBar("Error: Can't Find Process Id");
      return;
    }

    Utils().showBottomSheet(
      handleScrolling: true,
      children: [
        CreateTask(
          processId: processId,
        ),
      ],
    );
  }

  void _gotoNoteScreen(Process process) {
    NavigatorService.goto(
      Routes.noteScreen,
      arguments: [process],
    );
  }

  LinearGradient _getPriorityGradient(int priority){
    // blue gradient for high priority tasks
    var highPriorityGradient = LinearGradient(
      colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    // orange gradient for medium priority tasks
    var normalPriorityGradient = LinearGradient(
      colors: [Color(0xFFFFB75E), Color(0xFFED8F03)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Priority priorities = Priority();

    if(priority == priorities.high){
      return highPriorityGradient;
    } else if(priority == priorities.normal){
      return normalPriorityGradient;
    } else {
      // default gradient
      return LinearGradient(
        colors: [Colors.grey, Colors.grey[300]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}
