import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sufiyana_kaam/services/database/database-services.dart';
import 'package:sufiyana_kaam/xutils/widgets/utils.dart';
import '../permission-manager.dart';

class DatabaseBackupHelper {
  late String _dbName;

  DatabaseBackupHelper(){
    _dbName = DatabaseServices.create().databaseName;
  }

  /// Backup database to Downloads folder
  Future<void> backupDatabase() async {
    final status = await PermissionManager().requestStoragePermission();
    if (!status) {
      throw Exception('Storage permission not granted');
    }

    final dbPath = await DatabaseServices.create().getDbPath();
    final downloadsDir = Directory('/storage/emulated/0/Download');

    if (!downloadsDir.existsSync()) {
      throw Exception('Downloads folder not found');
    }

    final backupFile = File(join(downloadsDir.path, '${_dbName}_backup.db'));
    await File(dbPath).copy(backupFile.path);

    Utils().showSnackBar('✅ Backup saved to: ${backupFile.path}');
  }

  /// Restore database from a picked file
  Future<void> restoreDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select Backup File',
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result != null && result.files.single.path != null) {
      final backupPath = result.files.single.path!;
      final dbPath = await DatabaseServices.create().getDbPath();

      // Close the database before overwriting
      await DatabaseServices.create().closeDatabase();

      await File(backupPath).copy(dbPath);
      // Reopen the database after restoring
      await DatabaseServices.create().init();
      Utils().showSnackBar('✅ Database restored from: $backupPath');
    } else {
      Utils().showSnackBar('❌ No file selected');
    }
  }
}
