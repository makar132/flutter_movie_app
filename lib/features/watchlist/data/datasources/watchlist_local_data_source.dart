import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class WatchlistLocalDataSource {
  Future<List<Movie>> getWatchlist();
  Future<void> addToWatchlist(Movie movie);
  Future<void> removeFromWatchlist(int movieId);
  Future<bool> isInWatchlist(int movieId);
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String watchlistKey = 'watchlist';

  WatchlistLocalDataSourceImpl({required this.sharedPreferences});

  /// Get watchlist from storage
  @override
  Future<List<Movie>> getWatchlist() async {
    try {
      final jsonList = sharedPreferences.getStringList(watchlistKey) ?? [];

      return jsonList.map((jsonString) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return Movie(
          id: json['id'] as int,
          title: json['title'] as String? ?? '',
          overview: json['overview'] as String? ?? '',
          posterPath: json['poster_path'] as String? ?? '',
          backdropPath: json['backdrop_path'] as String? ?? '',
          voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
          releaseDate: json['release_date'] as String? ?? '',
          genreIds: List<int>.from(json['genre_ids'] as List? ?? []),
        );
      }).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  /// Add movie to watchlist
  @override
  Future<void> addToWatchlist(Movie movie) async {
    try {
      final watchlist = await getWatchlist();

      if (watchlist.any((m) => m.id == movie.id)) {
        return;
      }

      watchlist.add(movie);

      final jsonList = watchlist.map((m) {
        return jsonEncode({
          'id': m.id,
          'title': m.title,
          'overview': m.overview,
          'poster_path': m.posterPath,
          'backdrop_path': m.backdropPath,
          'vote_average': m.voteAverage,
          'release_date': m.releaseDate,
          'genre_ids': m.genreIds,
        });
      }).toList();

      await sharedPreferences.setStringList(watchlistKey, jsonList);
    } catch (e) {
      throw CacheException();
    }
  }

  /// Remove movie from watchlist
  @override
  Future<void> removeFromWatchlist(int movieId) async {
    try {
      final watchlist = await getWatchlist();
      watchlist.removeWhere((m) => m.id == movieId);

      final jsonList = watchlist.map((m) {
        return jsonEncode({
          'id': m.id,
          'title': m.title,
          'overview': m.overview,
          'poster_path': m.posterPath,
          'backdrop_path': m.backdropPath,
          'vote_average': m.voteAverage,
          'release_date': m.releaseDate,
          'genre_ids': m.genreIds,
        });
      }).toList();

      await sharedPreferences.setStringList(watchlistKey, jsonList);
    } catch (e) {
      throw CacheException();
    }
  }

  /// Check if movie is in watchlist
  @override
  Future<bool> isInWatchlist(int movieId) async {
    try {
      final watchlist = await getWatchlist();
      return watchlist.any((m) => m.id == movieId);
    } catch (e) {
      return false;
    }
  }
}