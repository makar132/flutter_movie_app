import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_details.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails extends UseCase<MovieDetails, int> {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, MovieDetails>> call(int movieId) async {
    return await repository.getMovieDetails(movieId);
  }
}