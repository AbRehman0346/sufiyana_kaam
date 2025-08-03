import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/xutils/widgets/xdropdown.dart';
import '../../services/database-services.dart';
import '../../xutils/colors/AppColors.dart';
import '../../xutils/widgets/utils.dart';
import '../../xutils/widgets/xtext.dart';

class CreateProcess extends StatefulWidget {
  Function(bool wasProcessSuccessful)? onProcessCreated;
  CreateProcess({super.key, this.onProcessCreated});

  @override
  State<CreateProcess> createState() => _CreateProcessState();
}

class _CreateProcessState extends State<CreateProcess> {
  final _processNameController = TextEditingController();
  int _priority = Priority().normal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Create New Process Title
              XText(
                "Create New Process",
                size: 24,
                bold: true,
                color: AppColors.secondaryText,
              ),
              SizedBox(height: 20),

              // Process Name TextField
              TextField(
                controller: _processNameController,
                decoration: InputDecoration(
                  labelText: "Process Name",
                  border: OutlineInputBorder(),
                ),
              ),
              Utils.height(20),

              // Priority Text and Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Priority: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  XDropdown(
                      items: Priority.all,
                      selectedItem: Priority.getValue(_priority),
                    onChanged: (text){
                      _priority = Priority.getPriority(text!);
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 20),

              // Create Process Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async => await createProcess(),
                    child: Text("Create Process"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> createProcess() async {
    String name = _processNameController.text.trim();
    if(name.isEmpty){
      Utils.showToast("Process name cannot be empty");
      return;
    }

    Process newProcess = Process(
      name: name,
      priority: _priority,
    );

    Utils.showProgressBar();

    await DatabaseServices.create().insertProcess(newProcess);

    Utils.hideProgressBar();

    if(widget.onProcessCreated != null){
      widget.onProcessCreated!(true);
    }
  }
}
