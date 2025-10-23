// lib/features/watchlist/data/repositories/watchlist_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getWatchlist() async {
    try {
      final watchlist = await localDataSource.getWatchlist();
      return Right(watchlist);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToWatchlist(Movie movie) async {
    try {
      await localDataSource.addToWatchlist(movie);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWatchlist(int movieId) async {
    try {
      await localDataSource.removeFromWatchlist(movieId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isInWatchlist(int movieId) async {
    try {
      final isIn = await localDataSource.isInWatchlist(movieId);
      return Right(isIn);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}