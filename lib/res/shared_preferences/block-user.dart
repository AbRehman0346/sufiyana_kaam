import 'package:shared_preferences/shared_preferences.dart';

class BlockUserSharedPreference{
  Future<void> blockUser(bool block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("block", block);
  }

  Future<bool> getBlockUser(bool block) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? block = prefs.getBool("block");

    return block ?? false;
  }
}