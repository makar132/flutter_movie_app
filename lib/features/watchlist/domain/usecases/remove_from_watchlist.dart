// lib/features/watchlist/domain/usecases/remove_from_watchlist.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watchlist_repository.dart';

class RemoveFromWatchlist extends UseCase<void, int> {
  final WatchlistRepository repository;

  RemoveFromWatchlist(this.repository);

  @override
  Future<Either<Failure, void>> call(int movieId) async {
    return await repository.removeFromWatchlist(movieId);
  }
}