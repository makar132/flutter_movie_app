// lib/features/movies/data/repositories/movie_repository_impl.dart - UPDATED WITH DETAILS

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/cast_model.dart';
import '../models/video_model.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({int page = 1}) async {
    return _getMovies(() => remoteDataSource.getNowPlayingMovies(page: page));
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    return _getMovies(() => remoteDataSource.getPopularMovies(page: page));
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1}) async {
    return _getMovies(() => remoteDataSource.getTopRatedMovies(page: page));
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1}) async {
    return _getMovies(() => remoteDataSource.getUpcomingMovies(page: page));
  }

  Future<Either<Failure, List<Movie>>> _getMovies(
      Future<List<Movie>> Function() getMovies,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await getMovies();
        return Right(movies);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMovieDetails(movieId);

        // Parse base movie
        final movieData = result['movie'];
        final baseMovie = MovieModel.fromJson(movieData);

        // Parse cast
        final castList = <Cast>[];
        final castData = result['credits']['cast'] as List?;
        if (castData != null) {
          castList.addAll(
            castData
                .take(15) // Only first 15 cast members
                .map((c) => CastModel.fromJson(c))
                .toList(),
          );
        }

        // Parse videos (trailers)
        final videoList = <Video>[];
        final videoData = result['videos']['results'] as List?;
        if (videoData != null) {
          videoList.addAll(
            videoData
                .where((v) => v['site'] == 'YouTube')
                .map((v) => VideoModel.fromJson(v))
                .toList(),
          );
        }

        // Parse similar movies
        final similarList = <Movie>[];
        final similarData = result['similar']['results'] as List?;
        if (similarData != null) {
          similarList.addAll(
            similarData
                .take(10) // Only first 10 similar movies
                .map((m) => MovieModel.fromJson(m))
                .toList(),
          );
        }

        // Calculate runtime
        final runtime = movieData['runtime'] != null
            ? '${movieData['runtime']} min'
            : null;

        // Format budget and revenue
        final budget = movieData['budget'] != null && movieData['budget'] > 0
            ? '\$${(movieData['budget'] / 1000000).toStringAsFixed(1)}M'
            : null;

        final revenue = movieData['revenue'] != null && movieData['revenue'] > 0
            ? '\$${(movieData['revenue'] / 1000000).toStringAsFixed(1)}M'
            : null;

        final movieDetails = MovieDetails(
          baseMovie: baseMovie,
          cast: castList,
          videos: videoList,
          similarMovies: similarList,
          runtime: runtime,
          budget: budget,
          revenue: revenue,
        );

        return Right(movieDetails);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}