import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static AppStorage? _instance;
  late final SharedPreferences _prefs;

  AppStorage._internal(this._prefs);

  static Future<AppStorage> init() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = AppStorage._internal(prefs);
    }
    return _instance!;
  }

  static AppStorage get instance {
    if (_instance == null) {
      throw Exception('AppStorage를 사용하기 전에 init()을 먼저 호출해야 합니다.');
    }
    return _instance!;
  }

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
}
