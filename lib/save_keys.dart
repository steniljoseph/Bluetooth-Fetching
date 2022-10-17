import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrenceModel {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static List<String> getStringList(String key) {
    List<String>? saveState = _prefs.getStringList(key);
    return saveState!;
  }
}
