import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sufiyana_kaam/models/online-version.dart';
import 'package:sufiyana_kaam/res/shared_preferences/version_store.dart';
import 'package:sufiyana_kaam/route-generator.dart';
import 'package:sufiyana_kaam/view/udpate_app/version-update-dialog.dart';
import 'package:sufiyana_kaam/xutils/NavigatorService.dart';

class Version{
  void actionOnVersion(VersionModel version) {
    // Version
    if (!version.isLatest) {
      if(version.isSevereVersionAvailable){
        NavigatorService.goto(Routes.versionUpdateScreen);
      }else{
        VersionUpdateDialog().show();
      }
    }
  }

  Future<void> init() async {
    VersionModel version = await checkAppVersion();

    /*
    * This function first checks the version number online....
    * if data is received from online and it compares it.. if app is latest then no problem.
    * if app is not latest then it saves that version data into sharedpreferences and notifies the user
    * to update the version.
    * if user updates the version and now app is to it's latest version. then it removes that
    * sharedpreferences data... and let's user use the app.
    *
    * Note: If no version data found, either online or from sharedpreferences then app just assumes
    * that it is at it's latest version and tells user not to worry.
    * */

    if(version.version != null){ // got the data from internet...
      if(version.isNotLatest){
        VersionSharedPreferences().setVersion(version);
        actionOnVersion(version);
      }else{ //if version is latest then there is no need for that data in sharedpreferences so remove it.
        VersionModel? version = await VersionSharedPreferences().getVersion();
        if(version != null){ // Means data found in sharedpreferences
          await VersionSharedPreferences().removeVersion(); // remove it.
        }
      }
    }else{ // In case version could not be obtained from internet...
      // Check In shared preference if there is any data regarding version
      VersionModel? version = await VersionSharedPreferences().getVersion();
      if(version != null){ // got the data from sharedpreferences.
        actionOnVersion(version);
      }
    }
  }

  Future<VersionModel> checkAppVersion() async {
    /*
    * This function get the version online and updates the version's singlon class...
    * if no data found online then it just returns empty VersionModel object with all the values
    * being null including version property.
    *
    * Note: It suppresses all the errors and exceptions.. so dev. will not notice anything going wrong.
    * */
    VersionModel version = VersionModel();
    try{
      String _onlineVersionLink = "https://gist.githubusercontent.com/AbRehman0346/6c27a5273638162529d5245c5673002d/raw/sufiyana-kam-version.json";

      // Fetch version.json from GitHub Gist
      http.Response response = await http.get(Uri.parse(_onlineVersionLink));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        version.updateFromJson(data);
      }
    }catch(e){
      log("============Error: Error occurred while checking Version Number\n$e\nFile: Version.dart\n\n");
    }
    return version;
  }
}