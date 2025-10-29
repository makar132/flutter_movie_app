import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../entities/movie_details.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1});

  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId);
}