import 'package:sufiyana_kaam/models/process-task.dart';

class Process{
  int? id;
  String name;
  String priority;
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
  String low = "Low";
  String normal = "Normal";
  String high = "High";

  List<String> get all => [low, normal, high];
}