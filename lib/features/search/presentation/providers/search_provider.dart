import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/enums/request_state.dart';
import '../../../../core/error/failures.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/search_movies.dart';

class SearchProvider extends ChangeNotifier {
  final SearchMovies searchMovies;

  Timer? _debounceTimer;

  List<Movie> _results = [];
  List<Movie> get results => _results;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _error = '';
  String get error => _error;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  SearchProvider({required this.searchMovies});

  /// Search with debouncing - waits 500ms after user stops typing
  void search(String query) {
    _currentQuery = query;

    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _results = [];
      _state = RequestState.empty;
      notifyListeners();
      return;
    }

    // Set loading state immediately for better UX
    _state = RequestState.loading;
    notifyListeners();

    // Wait 500ms before searching
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    final result = await searchMovies(query);

    result.fold(
          (failure) {
        _state = RequestState.error;
        _error = _mapFailureToMessage(failure);
        notifyListeners();
      },
          (movies) {
        _results = movies;
        _state = movies.isEmpty ? RequestState.empty : RequestState.success;
        notifyListeners();
      },
    );
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _results = [];
    _state = RequestState.empty;
    _currentQuery = '';
    _error = '';
    notifyListeners();
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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
