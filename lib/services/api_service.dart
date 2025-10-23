import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie.dart';

class ApiService {
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjM2MyMTRjMDMyOTkwYTk3YzgzZmVlMmU1NTlmODc4NyIsIm5iZiI6MTc1Njg5MzM5Ni45NTUwMDAyLCJzdWIiOiI2OGI4MTBkNDc3ZTE3NDUwYzM5OGE1YTMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.c99-dnuS7d3ItalnKlsw4muFambFOnfiZcTIgdJ4YSM';
  static const String _baseUrl = 'https://api.themoviedb.org/3/movie';

  // Helper function to fetch movie data
  Future<List<Movie>> fetchMovies(String category) async {
    final url = Uri.parse(
      '$_baseUrl/$category?language=en-US&page=1',
    );
    final headers = {
      'Authorization': 'Bearer $_apiKey',  // Include the API key in the Authorization header
    };
    debugPrint("url: $url");
    final response = await http.get(url,headers: headers);
    debugPrint("response : ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> movieJson = json.decode(response.body)['results'];
      return movieJson.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
