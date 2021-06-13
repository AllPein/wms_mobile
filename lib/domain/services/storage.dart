import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  late SharedPreferences _prefs;

  Future<Storage> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> save(key, value) async {
    return _prefs.setString(key, value);
  }

  String? get(key) {
    return _prefs.getString(key);
  }
}
