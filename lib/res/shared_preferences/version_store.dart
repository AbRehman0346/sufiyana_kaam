import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/online-version.dart';

class VersionSharedPreferences{
  Future<void> setVersion(VersionModel newVersionInfo) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.setString("version", newVersionInfo.version!);
    await instance.setString("updateUrl", newVersionInfo.updateUrl!);
    await instance.setString("severity", newVersionInfo.severity!);
  }

  Future<VersionModel?> getVersion() async {
    try{
      SharedPreferences instance = await SharedPreferences.getInstance();
      String? version = await instance.getString("version");
      String? updateUrl = await instance.getString("updateUrl");
      String? severity = await instance.getString("severity");

      if(version == null || updateUrl == null || severity == null){
        return null;
      }

      VersionModel model = VersionModel();
      model.version = version;
      model.updateUrl = updateUrl;
      model.severity = severity;

      return model;

    }catch(e){
      log("Error: error while getting version from sharedpreferences... \n$e\n\nFile Name: VersionSharedPreferences");
      return null;
    }
  }

  Future<void> removeVersion() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.remove("version");
    await instance.remove("updateUrl");
    await instance.remove("severity");
  }
}