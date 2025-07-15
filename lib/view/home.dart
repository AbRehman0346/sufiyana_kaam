import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/route-generator.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/view/create-process.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtext.dart';
import '../xutils/widgets/utils.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Key _futureKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Text(
                      //   'Hello, Michael',
                      //   style: TextStyle(fontSize: 16, color: Colors.black54),
                      // ),
                      // SizedBox(height: 4),
                      Text(
                        'Your Processes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  // const CircleAvatar(
                  //   radius: 24,
                  //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  // ),
                ],
              ),
              const SizedBox(height: 20),

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
            onPressed: showCreateProcessForm,
          child: XText("CREATE", color: Colors.white, size: 16, bold: true),
        ),
      ),
    );
  }

  void showCreateProcessForm(){
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
}

class _ProjectCard extends StatelessWidget {
  final Process process;

  const _ProjectCard({
    super.key,
    required this.process,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoNoteScreen(process),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: getPriorityGradient(process.priority),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Icon(Icons.more_horiz, color: Colors.white),
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
                      if(tasks[i].isCompleted){
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
          ],
        ),
      ),
    );
  }

  void gotoNoteScreen(Process process) {
    NavigatorService.goto(
      Routes.noteScreen,
      arguments: [process],
    );
  }

  LinearGradient getPriorityGradient(String priority){
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
