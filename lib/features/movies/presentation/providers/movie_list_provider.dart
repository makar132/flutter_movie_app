// lib/features/movies/presentation/providers/movie_list_provider.dart - UPDATED FOR PAGINATION

import 'package:flutter/foundation.dart';
import '../../../../core/enums/request_state.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_upcoming_movies.dart';
import '../../domain/usecases/movie_params.dart';

class MovieListProvider extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetUpcomingMovies getUpcomingMovies;

  MovieListProvider({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getUpcomingMovies,
  });

  // Now Playing Movies
  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  RequestState _nowPlayingState = RequestState.loading;
  RequestState get nowPlayingState => _nowPlayingState;

  String _nowPlayingError = '';
  String get nowPlayingError => _nowPlayingError;

  // Popular Movies
  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;

  RequestState _popularState = RequestState.loading;
  RequestState get popularState => _popularState;

  String _popularError = '';
  String get popularError => _popularError;

  // Top Rated Movies
  List<Movie> _topRatedMovies = [];
  List<Movie> get topRatedMovies => _topRatedMovies;

  RequestState _topRatedState = RequestState.loading;
  RequestState get topRatedState => _topRatedState;

  String _topRatedError = '';
  String get topRatedError => _topRatedError;

  // Upcoming Movies
  List<Movie> _upcomingMovies = [];
  List<Movie> get upcomingMovies => _upcomingMovies;

  RequestState _upcomingState = RequestState.loading;
  RequestState get upcomingState => _upcomingState;

  String _upcomingError = '';
  String get upcomingError => _upcomingError;

  /// Fetch all movie categories (page 1 only for home page)
  Future<void> fetchAllMovies() async {
    await Future.wait([
      fetchNowPlayingMovies(),
      fetchPopularMovies(),
      fetchTopRatedMovies(),
      fetchUpcomingMovies(),
    ]);
  }

  /// Fetch Now Playing Movies (page 1)
  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingMovies(const MovieParams(page: 1));

    result.fold(
          (failure) {
        _nowPlayingState = RequestState.error;
        _nowPlayingError = _mapFailureToMessage(failure);
        notifyListeners();
      },
          (movies) {
        _nowPlayingMovies = movies;
        _nowPlayingState =
        movies.isEmpty ? RequestState.empty : RequestState.success;
        notifyListeners();
      },
    );
  }

  /// Fetch Popular Movies (page 1)
  Future<void> fetchPopularMovies() async {
    _popularState = RequestState.loading;
    notifyListeners();

    final result = await getPopularMovies(const MovieParams(page: 1));

    result.fold(
          (failure) {
        _popularState = RequestState.error;
        _popularError = _mapFailureToMessage(failure);
        notifyListeners();
      },
          (movies) {
        _popularMovies = movies;
        _popularState =
        movies.isEmpty ? RequestState.empty : RequestState.success;
        notifyListeners();
      },
    );
  }

  /// Fetch Top Rated Movies (page 1)
  Future<void> fetchTopRatedMovies() async {
    _topRatedState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedMovies(const MovieParams(page: 1));

    result.fold(
          (failure) {
        _topRatedState = RequestState.error;
        _topRatedError = _mapFailureToMessage(failure);
        notifyListeners();
      },
          (movies) {
        _topRatedMovies = movies;
        _topRatedState =
        movies.isEmpty ? RequestState.empty : RequestState.success;
        notifyListeners();
      },
    );
  }

  /// Fetch Upcoming Movies (page 1)
  Future<void> fetchUpcomingMovies() async {
    _upcomingState = RequestState.loading;
    notifyListeners();

    final result = await getUpcomingMovies(const MovieParams(page: 1));

    result.fold(
          (failure) {
        _upcomingState = RequestState.error;
        _upcomingError = _mapFailureToMessage(failure);
        notifyListeners();
      },
          (movies) {
        _upcomingMovies = movies;
        _upcomingState =
        movies.isEmpty ? RequestState.empty : RequestState.success;
        notifyListeners();
      },
    );
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