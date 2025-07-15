import 'dart:developer';

class ProcessTask{
  int? id;
  String title;
  String description;
  String? date;
  String? time;
  int order;
  String priority;
  String status;
  int processId;
  ProcessTask({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.order,
    required this.priority,
    required this.processId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    var f = ProcessTaskFields();
    return {
      f.title: title,
      f.description: description,
      f.date: date,
      f.time: time,
      f.order: order,
      f.priority: priority,
      f.processId: processId,
      f.status: status,
    };
  }

  factory ProcessTask.fromMap(Map<String, dynamic> map) {
    var f = ProcessTaskFields();
    return ProcessTask(
      id: map[f.id],
      title: map[f.title],
      description: map[f.description],
      date: map[f.date],
      time: map[f.time],
      order: map[f.order],
      priority: map[f.priority],
      processId: map[f.processId],
      status: map[f.status] ?? "pending", // Default status if not provided
    );
  }

  bool get isPending => status.toLowerCase() == ProcessTaskStatus.pending.toLowerCase();

  bool get isInProgress => status.toLowerCase() == ProcessTaskStatus.inProgress.toLowerCase();

  bool get isCompleted => status.toLowerCase() == ProcessTaskStatus.completed.toLowerCase();

  bool get isCancelled => status.toLowerCase() == ProcessTaskStatus.cancelled.toLowerCase();
}

class ProcessTaskStatus {
  static const String pending = "Pending";
  static const String inProgress = "In Progress";
  static const String completed = "Completed";
  static const String cancelled = "Cancelled";

  static List<String> get all => [
    pending,
    inProgress,
    completed,
    cancelled,
  ];
}

class ProcessTaskFields{
  String id = "id";
  String title = "title";
  String description = "description";
  String date = "task_date";
  String time = "task_time";
  String order = "task_order";
  String priority = "priority";
  String processId = "process_id";
  String status = "status";
}