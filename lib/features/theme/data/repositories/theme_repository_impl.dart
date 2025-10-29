import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> isDarkMode() async {
    try {
      final isDark = await localDataSource.isDarkMode();
      return Right(isDark);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setDarkMode(bool isDark) async {
    try {
      await localDataSource.setDarkMode(isDark);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}