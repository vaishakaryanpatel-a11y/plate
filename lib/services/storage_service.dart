import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._preferences);

  final SharedPreferences _preferences;

  static Future<StorageService> create() async {
    return StorageService(await SharedPreferences.getInstance());
  }

  int get waterCount => _preferences.getInt('waterCount') ?? 0;

  Future<void> saveWaterCount(int value) {
    return _preferences.setInt('waterCount', value);
  }
}
