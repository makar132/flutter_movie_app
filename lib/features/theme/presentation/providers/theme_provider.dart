import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_theme.dart';
import '../../domain/usecases/set_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final GetTheme getTheme;
  final SetTheme setTheme;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider({
    required this.getTheme,
    required this.setTheme,
  });

  /// Load theme preference from storage
  Future<void> loadTheme() async {
    final result = await getTheme(NoParams());

    result.fold(
          (failure) {
        // Default to light mode on failure
        _isDarkMode = false;
      },
          (isDark) {
        _isDarkMode = isDark;
        notifyListeners();
      },
    );
  }

  /// Toggle theme and save to storage
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    // Save to storage
    final result = await setTheme(_isDarkMode);

    result.fold(
          (failure) {
        // Revert on failure
        _isDarkMode = !_isDarkMode;
        notifyListeners();
      },
          (success) {
        // Theme saved successfully
      },
    );
  }
}