import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getTopRatedMovies({int page = 1});
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});

  Future<Map<String, dynamic>> getMovieDetails(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    return _getMovies('/movie/now_playing', page: page);
  }

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    return _getMovies('/movie/popular', page: page);
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    return _getMovies('/movie/top_rated', page: page);
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    return _getMovies('/movie/upcoming', page: page);
  }

  Future<List<MovieModel>> _getMovies(String endpoint, {int page = 1}) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}$endpoint',
        queryParameters: {
          'language': 'en-US',
          'page': page,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.apiKey}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List results = response.data['results'] ?? [];
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

  @override
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    try {
      // Fetch movie details, cast, videos, and similar movies in parallel
      final responses = await Future.wait([
        dio.get(
          '${AppConstants.baseUrl}/movie/$movieId',
          options: Options(
            headers: {'Authorization': 'Bearer ${AppConstants.apiKey}'},
          ),
        ),
        dio.get(
          '${AppConstants.baseUrl}/movie/$movieId/credits',
          options: Options(
            headers: {'Authorization': 'Bearer ${AppConstants.apiKey}'},
          ),
        ),
        dio.get(
          '${AppConstants.baseUrl}/movie/$movieId/videos',
          options: Options(
            headers: {'Authorization': 'Bearer ${AppConstants.apiKey}'},
          ),
        ),
        dio.get(
          '${AppConstants.baseUrl}/movie/$movieId/similar',
          options: Options(
            headers: {'Authorization': 'Bearer ${AppConstants.apiKey}'},
          ),
        ),
      ]);

      if (responses.every((r) => r.statusCode == 200)) {
        return {
          'movie': responses[0].data,
          'credits': responses[1].data,
          'videos': responses[2].data,
          'similar': responses[3].data,
        };
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