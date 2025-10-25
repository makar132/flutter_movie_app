// lib/features/search/domain/usecases/search_movies.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/search_repository.dart';

class SearchMovies extends UseCase<List<Movie>, String> {
  final SearchRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(String query) async {
    if (query.isEmpty) {
      return const Right([]);
    }
    return await repository.searchMovies(query);
  }
}
