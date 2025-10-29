import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'movie_params.dart';

class GetNowPlayingMovies extends UseCase<List<Movie>, MovieParams> {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieParams params) async {
    return await repository.getNowPlayingMovies(page: params.page);
  }
}