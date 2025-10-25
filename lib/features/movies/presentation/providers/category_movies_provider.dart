// lib/features/movies/presentation/providers/category_movies_provider.dart

import 'package:flutter/foundation.dart';
import '../../../../core/enums/request_state.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_upcoming_movies.dart';
import '../../domain/usecases/movie_params.dart';

enum MovieCategory { nowPlaying, popular, topRated, upcoming }

class CategoryMoviesProvider extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetUpcomingMovies getUpcomingMovies;

  CategoryMoviesProvider({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getUpcomingMovies,
  });

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  RequestState _state = RequestState.loading;
  RequestState get state => _state;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  String _error = '';
  String get error => _error;

  MovieCategory? _category;

  /// Load initial page
  Future<void> loadMovies(MovieCategory category) async {
    _category = category;
    _currentPage = 1;
    _movies.clear();
    _hasMore = true;
    _state = RequestState.loading;
    notifyListeners();

    await _fetchMovies();
  }

  /// Load next page (for infinite scroll)
  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMore || _state == RequestState.loading) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    await _fetchMovies();

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Refresh (pull-to-refresh)
  Future<void> refresh() async {
    _currentPage = 1;
    _movies.clear();
    _hasMore = true;
    _state = RequestState.loading;
    notifyListeners();

    await _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final params = MovieParams(page: _currentPage);
    final result = await _getMoviesForCategory(params);

    result.fold(
          (failure) {
        if (_currentPage == 1) {
          _state = RequestState.error;
          _error = _mapFailureToMessage(failure);
        } else {
          // If error on page > 1, keep existing movies and stop pagination
          _hasMore = false;
        }
        notifyListeners();
      },
          (newMovies) {
        if (newMovies.isEmpty) {
          _hasMore = false;
          if (_currentPage == 1) {
            _state = RequestState.empty;
          }
        } else {
          _movies.addAll(newMovies);
          _state = RequestState.success;

          // TMDB usually has max 500 pages, but we check for empty response
          if (newMovies.length < 20) {
            _hasMore = false; // Probably last page
          }
        }
        notifyListeners();
      },
    );
  }

  Future _getMoviesForCategory(MovieParams params) async {
    switch (_category) {
      case MovieCategory.nowPlaying:
        return await getNowPlayingMovies(params);
      case MovieCategory.popular:
        return await getPopularMovies(params);
      case MovieCategory.topRated:
        return await getTopRatedMovies(params);
      case MovieCategory.upcoming:
        return await getUpcomingMovies(params);
      default:
        return await getPopularMovies(params);
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error. Please try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      default:
        return 'Unexpected error occurred.';
    }
  }
}