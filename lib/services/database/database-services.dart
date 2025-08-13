import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:sufiyana_kaam/models/process.dart';
import 'package:sufiyana_kaam/services/notification_service.dart';
import 'package:sufiyana_kaam/xutils/XDateTime.dart';

import '../../models/process-task.dart';
import '../../xutils/widgets/utils.dart';

class DatabaseServices{
  // Singleton Class...

  DatabaseServices._internal();

  static final _instance = DatabaseServices._internal();

  factory DatabaseServices.create(){
    return _instance;
  }

  static Database? _database;
  String databaseName = "data.db";

  Future<void> init() async {
    String databasePath = await getDbPath();

    String createProcessTableQuery = """
    CREATE TABLE processes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL,
    priority INT NOT NULL
); 
    """;


    String createProcessTaskTableQuery = """
    CREATE TABLE process_tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    task_date TEXT,
    task_time TEXT,
    task_order INTEGER NOT NULL,
    priority INT NOT NULL,
    process_id INTEGER NOT NULL,
    status TEXT DEFAULT 'Pending'
  );
    """;

    _database = await openDatabase(
        databasePath,
        version: 1,
      onCreate: (Database db, int version) async {
          await db.execute(createProcessTableQuery);
          await db.execute(createProcessTaskTableQuery);
      }
    );
  }

  Future<String> getDbPath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, databaseName);
  }

  Future<void> _handleDatabaseBeingNull() async {
    if(_database == null){
      await init();
    }
  }

  Future<void> insertProcess(Process process) async {
      await _handleDatabaseBeingNull();
      String insertQuery = """
      INSERT INTO processes(name, priority)
      VALUES(?, ?)
      """;
      await _database!.rawInsert(insertQuery, [process.name, process.priority]);
  }

  Future<void> updateProcess(Process newProcess) async {
    await _handleDatabaseBeingNull();
    String updateQuery = """
      UPDATE processes
      SET name = ?,
      priority = ?
      WHERE id = ?
    """;
    await _database!.rawUpdate(updateQuery, [newProcess.name, newProcess.priority, newProcess.id]);
  }

  Future<List<Map>> fetchProcesses() async {
    await _handleDatabaseBeingNull();
    String query = """
    SELECT id, name, priority FROM processes ORDER BY priority DESC   
    """;
    List<Map> response = await _database!.rawQuery(query);
    return response;
  }

  Future<ProcessTask> insertProcessTask(ProcessTask task) async {
    await _handleDatabaseBeingNull();
    String insertQuery = """
    INSERT INTO process_tasks(title, description, task_date, task_time, task_order, priority, process_id)
    VALUES(?, ?, ?, ?, ?, ?, ?)
    """;
    int id = await _database!.rawInsert(insertQuery, [
      task.title,
      task.description,
      task.date.date,
      task.time,
      task.order,
      task.priority,
      task.processId,
    ]);

    task.id = id; // Set the ID back to the task object

    NotificationService().scheduleNotificationBasedOnPriority(task);

    return task;
  }

  Future<int> getProcessTaskCount(int processId) async {
    await _handleDatabaseBeingNull();
    String query = """
    SELECT COUNT(*) as count FROM process_tasks WHERE process_id = ?
    """;
    List<Map> response = await _database!.rawQuery(query, [processId]);

    if(response.isNotEmpty && response[0]['count'] != null){
      return response[0]['count'] as int;
    }
    return 0;
  }

  Future<List<ProcessTask>> fetchProcessTasks(int processId) async {
    await _handleDatabaseBeingNull();
    String query = """
    SELECT * FROM process_tasks WHERE process_id = ? ORDER BY task_order
    """;
    List<Map<String, dynamic>> response = await _database!.rawQuery(query, [processId]);
    List<ProcessTask> tasks = response.map((e) => ProcessTask.fromMap(e)).toList();
    return tasks;
  }

  Future<void> updateTask(ProcessTask task) async {
    await _handleDatabaseBeingNull();
    String updateQuery = """
    UPDATE process_tasks 
    SET title = ?,
    description = ?,
    task_date = ?,
    task_time = ?,
    priority = ?,
    status = ?
    WHERE id = ?
    """;

    await _database!.rawUpdate(updateQuery, [
      task.title,
      task.description,
      task.date.date,
      task.time,
      task.priority,
      task.status.status,
      task.id,
    ]);

    // Reschedule notification if the task has a date or time
    NotificationService().scheduleNotificationBasedOnPriority(task);
  }

  Future<void> sortProcessTasks(List<ProcessTask> tasks) async {
    await _handleDatabaseBeingNull();
    String updateQuery = """
    UPDATE process_tasks SET task_order = ? WHERE id = ?
    """;
    Batch batch = _database!.batch();
    for (int i=0; i<tasks.length; i++) {
      batch.rawUpdate(
        updateQuery,
        [i, tasks[i].id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> updateProcessTaskStatus(int taskId, String status) async {
    await _handleDatabaseBeingNull();
    String updateQuery = """
    UPDATE process_tasks SET status = ? WHERE id = ?
    """;
    await _database!.rawUpdate(updateQuery, [status, taskId]);
  }

  Future<void> deleteProcessTask(int taskId) async {
    await _handleDatabaseBeingNull();
    String deleteQuery = """
    DELETE FROM process_tasks WHERE id = ?
    """;
    await _database!.rawDelete(deleteQuery, [taskId]);
    await NotificationService().cancelNotification(taskId);
  }

  Future<void> deleteProcess(int i) async {
    // Cancel all notifications associated with the process
    await NotificationService().cancelAllNotificationsForProcess(i);


    await _handleDatabaseBeingNull();

    // Delete Process
    String deleteProcessQuery = """
    DELETE FROM processes WHERE id = ?
    """;
    await _database!.rawDelete(deleteProcessQuery, [i]);

    // Delete all tasks associated with the process
    String deleteTasksQuery = """
    DELETE FROM process_tasks WHERE process_id = ?
    """;
    await _database!.rawDelete(deleteTasksQuery, [i]);
  }

  Future<void> closeDatabase() async {
    try {
      await _database!.close();
    } catch (_) {
      Utils().showSnackBar("Error: Could not close the database.");
    }
  }
}