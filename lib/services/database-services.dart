import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:sufiyana_kaam/models/process.dart';

import '../models/process-task.dart';

class DatabaseServices{
  // Singleton Class...

  DatabaseServices._internal();

  static final _instance = DatabaseServices._internal();

  factory DatabaseServices.create(){
    return _instance;
  }

  static Database? _database;

  Future<void> init() async {
    var directory = await getDatabasesPath();

    String databasePath = join(directory, "data.db");

    String createProcessTableQuery = """
    CREATE TABLE processes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL,
    priority TEXT NOT NULL
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
    priority TEXT NOT NULL,
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

  Future<List<Map>> fetchProcesses() async {
    await _handleDatabaseBeingNull();
    String query = """
    SELECT id, name, priority FROM processes    
    """;
    List<Map> response = await _database!.rawQuery(query);
    return response;
  }

  Future<int> insertProcessTask(ProcessTask task) async {
    await _handleDatabaseBeingNull();
    String insertQuery = """
    INSERT INTO process_tasks(title, description, task_date, task_time, task_order, priority, process_id)
    VALUES(?, ?, ?, ?, ?, ?, ?)
    """;
    int id = await _database!.rawInsert(insertQuery, [
      task.title,
      task.description,
      task.date,
      task.time,
      task.order,
      task.priority,
      task.processId,
    ]);
    return id;
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
  }
}