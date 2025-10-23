// lib/features/watchlist/domain/usecases/get_watchlist.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlist extends UseCase<List<Movie>, NoParams> {
  final WatchlistRepository repository;

  GetWatchlist(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getWatchlist();
  }
}