// lib/features/theme/domain/usecases/set_theme.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/theme_repository.dart';

class SetTheme extends UseCase<void, bool> {
  final ThemeRepository repository;

  SetTheme(this.repository);

  @override
  Future<Either<Failure, void>> call(bool isDark) async {
    return await repository.setDarkMode(isDark);
  }
}