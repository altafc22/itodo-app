import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtil {
  final SharedPreferences _prefs;

  SharedPrefsUtil._(this._prefs);

  static Future<SharedPrefsUtil> getInstance(
      SharedPreferences preferences) async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = preferences;
    return SharedPrefsUtil._(prefs);
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }
}
