import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  static StorageRepository? _storageUtil;
  static SharedPreferences? _preferences;

  static Future<StorageRepository> getInstance() async {
    if (_storageUtil == null) {
      final secureStorage = StorageRepository._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil!;
  }

  StorageRepository._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /////// LIST

  static List getList(String key,
      {List<Map<String, dynamic>> defValue = const []}) {
    if (_preferences == null) return List.empty(growable: true);
    return _preferences!.getStringList(key) ?? List.empty(growable: true);
  }

  static Future<bool>? putList(String key, List<String> value) {
    if (_preferences == null) return null;
    return _preferences!.setStringList(key, value);
  }

  static Future<bool>? updateList(String key, List<String> value) {
    if (_preferences == null) return null;
    return _preferences!.setStringList(key, value);
  }

  /////// STRING

  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(key) ?? defValue;
  }

  static Future<bool>? putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }

  static Future<bool>? deleteString(String key) {
    if (_preferences == null) return null;
    return _preferences!.remove(key);
  }

  static Future<bool>? updateString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }

  ///// DOUBLE

  static double getDouble(String key, {double defValue = 0.0}) {
    if (_preferences == null) return defValue;
    return _preferences!.getDouble(key) ?? defValue;
  }

  static Future<bool>? putDouble(String key, double value) {
    if (_preferences == null) return null;
    return _preferences!.setDouble(key, value);
  }

  static Future<bool>? deleteDouble(String key) {
    if (_preferences == null) return null;
    return _preferences!.remove(key);
  }

  static Future<bool>? updateDouble(String key, double value) {
    if (_preferences == null) return null;
    return _preferences!.setDouble(key, value);
  }

  //////////  BOOLEAN

  static bool getBool(String key, {bool defValue = true}) {
    if (_preferences == null) return defValue;
    return _preferences!.getBool(key) ?? defValue;
  }

  static Future<bool>? putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences!.setBool(key, value);
  }

  static Future<bool>? deleteBool(String key) {
    if (_preferences == null) return null;
    return _preferences!.remove(key);
  }

  static Future<bool>? updateBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences!.setBool(key, value);
  }
}
