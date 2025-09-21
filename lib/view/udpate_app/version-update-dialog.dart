import 'package:flutter/material.dart';
import 'package:sufiyana_kaam/models/online-version.dart';
import 'package:sufiyana_kaam/xutils/GlobalContext.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../xutils/widgets/xtext.dart';

class VersionUpdateDialog {
  Future<void> show() async {

    VersionModel version = VersionModel();

    Future<void> _launchUpdateUrl() async {
      if(version.updateUrl != null){
        final Uri uri = Uri.parse(version.updateUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    }

    showDialog(
      context: GlobalContext.getContext,
      barrierDismissible: true, // ✅ user can dismiss it
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.system_update, color: Colors.blueAccent),
              SizedBox(width: 8),
              XText("New Version Available", size: 18),
            ],
          ),
          content: const Text(
            "A newer version is available on the Play Store.\n\n"
                "Update now to enjoy the latest features and improvements.",
          ),
          actions: [
            TextButton(
              child: const Text("Later"),
              onPressed: () {
                Navigator.of(context).pop(); // dismiss dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Update"),
              onPressed: () {
                _launchUpdateUrl();
                Navigator.of(context).pop(); // close after pressing
              },
            ),
          ],
        );
      },
    );
  }
}
