
// lib/features/watchlist/domain/usecases/add_to_watchlist.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/watchlist_repository.dart';

class AddToWatchlist extends UseCase<void, Movie> {
  final WatchlistRepository repository;

  AddToWatchlist(this.repository);

  @override
  Future<Either<Failure, void>> call(Movie movie) async {
    return await repository.addToWatchlist(movie);
  }
}