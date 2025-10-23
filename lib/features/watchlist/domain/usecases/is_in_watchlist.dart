// lib/features/watchlist/domain/usecases/is_in_watchlist.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watchlist_repository.dart';

class IsInWatchlist extends UseCase<bool, int> {
  final WatchlistRepository repository;

  IsInWatchlist(this.repository);

  @override
  Future<Either<Failure, bool>> call(int movieId) async {
    return await repository.isInWatchlist(movieId);
  }
}