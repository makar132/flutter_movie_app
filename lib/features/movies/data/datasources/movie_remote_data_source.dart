// lib/features/movies/data/datasources/movie_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> getUpcomingMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    return await _getMovies('${AppConstants.baseUrl}/movie/now_playing');
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    return await _getMovies('${AppConstants.baseUrl}/movie/popular');
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    return await _getMovies('${AppConstants.baseUrl}/movie/top_rated');
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    return await _getMovies('${AppConstants.baseUrl}/movie/upcoming');
  }

  Future<List<MovieModel>> _getMovies(String url) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {'language': 'en-US', 'page': 1},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.apiKey}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}