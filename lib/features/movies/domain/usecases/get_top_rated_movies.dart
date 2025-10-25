// lib/features/movies/domain/usecases/get_top_rated_movies.dart - UPDATED WITH PAGINATION

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'movie_params.dart';

class GetTopRatedMovies extends UseCase<List<Movie>, MovieParams> {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieParams params) async {
    return await repository.getTopRatedMovies(page: params.page);
  }
}