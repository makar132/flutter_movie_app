// lib/features/movies/data/repositories/movie_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final movieModels = await remoteDataSource.getNowPlayingMovies();
        return Right(movieModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final movieModels = await remoteDataSource.getPopularMovies();
        return Right(movieModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final movieModels = await remoteDataSource.getTopRatedMovies();
        return Right(movieModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final movieModels = await remoteDataSource.getUpcomingMovies();
        return Right(movieModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}