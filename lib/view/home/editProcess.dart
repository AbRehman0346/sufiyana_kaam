import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/xutils/widgets/xdropdown.dart';
import '../../services/database-services.dart';
import '../../xutils/colors/AppColors.dart';
import '../../xutils/widgets/utils.dart';
import '../../xutils/widgets/xtext.dart';

class EditProcess extends StatefulWidget {
  Process process;
  Function(bool wasProcessSuccessful)? onProcessEdited;
  EditProcess({
    super.key,
    required this.process,
    this.onProcessEdited
  });

  @override
  State<EditProcess> createState() => _EditProcessState();
}

class _EditProcessState extends State<EditProcess> {
  late final TextEditingController _processNameController;
  late int _priority;

  @override
  void initState() {
    _processNameController = TextEditingController(text: widget.process.name);
    _priority = widget.process.priority;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: XText("EDIT PROCESS"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Priority: ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Utils.width(50),
                    XDropdown(
                      items: Priority.all,
                      selectedItem: Priority.getValue(_priority),
                      onChanged: (text){
                        _priority = Priority.getPriority(text!);
                      },
                    ),
                  ],
                ),

                SizedBox(height: 70),

                // Update Process Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async => await _updateProcess(),
                      child: Text("Update Process"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProcess() async {
    String name = _processNameController.text.trim();
    if(name.isEmpty){
      Utils.showToast("Process name cannot be empty");
      return;
    }

    Process newProcess = Process(
      id: widget.process.id,
      name: name,
      priority: _priority,
    );

    Utils.showProgressBar();

    await DatabaseServices.create().updateProcess(newProcess);

    Utils.hideProgressBar();

    if(widget.onProcessEdited != null){
      widget.onProcessEdited!(true);
    }
  }
}
