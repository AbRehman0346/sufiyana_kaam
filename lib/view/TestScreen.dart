import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sufiyana_kaam/models/process-task.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/services/database-services.dart';
import 'package:sufiyana_kaam/xutils/widgets/xbutton.dart';
import 'package:sufiyana_kaam/xutils/widgets/xdropdown.dart';
import 'package:sufiyana_kaam/xutils/widgets/xtext.dart';
import '../xutils/colors/AppColors.dart';
import '../xutils/GlobalContext.dart';
import '../xutils/widgets/utils.dart';
import '../xutils/widgets/xtextfield.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  String priority = "Low";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBox(),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildBox(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          XText("ADD TASK", size: 30, bold: true, color: AppColors.secondaryText),
          Utils.height(20),
          XTextField(
            controller: titleController,
            hint: "Process Title",
            borderRadius: 10,
          ),
          Utils.height(20),
          XTextField(
            controller: descController,
            hint: "Process Description",
            borderRadius: 10,
            minLines: 3,
          ),

          Utils.height(20),

          SizedBox(
            width: Utils.screenWidth * 0.6,
            child: XDropdown(
              items: Priority().all,
              selectedItem: Priority().normal,
              isExpanded: true,
            ),
          ),

          Utils.height(40),
        //   Add Button Row...
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              XButton(
                  text: "ADD PROCESS",
                  onPressed: () async {
                    await DatabaseServices.create().insertProcess(
                        Process(
                            name: titleController.text,
                            priority: Priority().normal,
                        ),
                    );
                    Fluttertoast.showToast(msg: "Process Inserted...");
                  },
              ),
            ],
          ),
          Utils.height(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              XButton(
                  text: "GET PROCESS",
                onPressed: (){setState(() {});},
              ),
            ],
          ),

          FutureBuilder(
            key: Key(Random().nextInt(100).toString()),
              future: DatabaseServices.create().fetchProcesses(),
              builder: (BuildContext context, AsyncSnapshot snap){
            if(!snap.hasData){
              return XText("Loading...");
            }
            List<Map> maps = snap.data;

            if(maps.isEmpty){
              return XText("No Data Found");   
            }

            return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(
                  maps.length,
                  (index){
                    var process = Process.fromMap(maps[index]);
                    return XText(process.name);
                  }),
            );


          }),
        ],
      ),
    );
  }
}
