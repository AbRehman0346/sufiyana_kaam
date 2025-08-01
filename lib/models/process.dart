import 'package:sufiyana_kaam/models/process-task.dart';

class Process{
  int? id;
  String name;
  int priority;
  String get getPriorityValue => Priority.getValue(priority);

  List<ProcessTask> tasks;

  Process({
    this.id,
    required this.name,
    required this.priority,
    this.tasks = const [],
  });

  Map<String, dynamic> toMap(){
    ProcessFields f = ProcessFields();
    return {
      f.name: name,
      f.priority: priority
    };
  }

  factory Process.fromMap(Map process){
    ProcessFields f = ProcessFields();
    return Process(
      id: process[f.id],
      name: process[f.name],
      priority: process[f.priority],
    );
  }
}

class ProcessFields{
  String id = "id";
  String name = "name";
  String priority = "priority";
}

class Priority{
  int low = 0;
  int normal = 1;
  int high = 2;

  static final String _low = "Low";
  static final String _normal = "Normal";
  static final String _high = "High";

  static List<String> get all => [_low, _normal, _high];

  static String getValue(int priority) => all[priority];

  static int getPriority(String priority) {
    if(priority == _low) return 0;
    if(priority == _normal) return 1;
    if(priority == _high) return 2;
    return 1; // Default to normal
  }
}