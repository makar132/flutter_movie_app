import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../../movies/data/models/movie_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MovieModel>> searchMovies(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/search/movie',
        queryParameters: {
          'query': query,
          'language': 'en-US',
          'page': 1,
        },
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
