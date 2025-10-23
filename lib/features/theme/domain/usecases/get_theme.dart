// lib/features/theme/domain/usecases/get_theme.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/theme_repository.dart';

class GetTheme extends UseCase<bool, NoParams> {
  final ThemeRepository repository;

  GetTheme(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isDarkMode();
  }
}