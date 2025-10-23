// lib/features/watchlist/domain/repositories/watchlist_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<Movie>>> getWatchlist();
  Future<Either<Failure, void>> addToWatchlist(Movie movie);
  Future<Either<Failure, void>> removeFromWatchlist(int movieId);
  Future<Either<Failure, bool>> isInWatchlist(int movieId);
}