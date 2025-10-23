// lib/features/theme/domain/repositories/theme_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ThemeRepository {
  Future<Either<Failure, bool>> isDarkMode();
  Future<Either<Failure, void>> setDarkMode(bool isDark);
}