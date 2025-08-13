import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/services/database/backup_handler.dart';
import 'package:sufiyana_kaam/xutils/widgets/utils.dart';

class BackupView extends StatefulWidget {
  const BackupView({super.key});

  @override
  State<BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try{
                  await DatabaseBackupHelper().backupDatabase();
                }catch(e){
                  log('========================================================\nBackup failed: $e');
                  Utils().showSnackBar(e.toString());
                }
              },
              child: const Text('Backup Database'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                try{
                  DatabaseBackupHelper().restoreDatabase();
                }catch(e){
                  log('========================================================\nBackup failed: $e');
                  Utils().showSnackBar(e.toString());
                }
              },
              child: const Text('Restore Database'),
            ),
          ],
        ),
      ),
    );
  }
}

