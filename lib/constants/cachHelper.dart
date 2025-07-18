import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save data
  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (_prefs == null) return false;
    if (value is String) return await _prefs!.setString(key, value);
    if (value is int) return await _prefs!.setInt(key, value);
    if (value is bool) return await _prefs!.setBool(key, value);
    if (value is double) return await _prefs!.setDouble(key, value);
    return false;
  }

  /// Retrieve data
  static dynamic getData({required String key}) {
    return _prefs?.get(key);
  }

  /// Remove data
  static Future<bool> removeData({required String key}) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }
}
