// lib/features/theme/data/datasources/theme_local_data_source.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';

abstract class ThemeLocalDataSource {
  Future<bool> isDarkMode();
  Future<void> setDarkMode(bool isDark);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String themeKey = 'isDarkMode';

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isDarkMode() async {
    try {
      return sharedPreferences.getBool(themeKey) ?? false;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    try {
      await sharedPreferences.setBool(themeKey, isDark);
    } catch (e) {
      throw CacheException();
    }
  }
}