// lib/features/watchlist/presentation/providers/watchlist_provider.dart

import 'package:flutter/foundation.dart';
import '../../../../core/enums/request_state.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/add_to_watchlist.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/is_in_watchlist.dart';
import '../../domain/usecases/remove_from_watchlist.dart';

class WatchlistProvider extends ChangeNotifier {
  final GetWatchlist getWatchlist;
  final AddToWatchlist addToWatchlist;
  final RemoveFromWatchlist removeFromWatchlist;
  final IsInWatchlist isInWatchlist;

  List<Movie> _watchlist = [];
  List<Movie> get watchlist => _watchlist;

  RequestState _state = RequestState.loading;
  RequestState get state => _state;

  String _error = '';
  String get error => _error;

  WatchlistProvider({
    required this.getWatchlist,
    required this.addToWatchlist,
    required this.removeFromWatchlist,
    required this.isInWatchlist,
  });

  /// Load watchlist from storage
  Future<void> loadWatchlist() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getWatchlist(NoParams());

    result.fold(
          (failure) {
        _state = RequestState.error;
        _error = 'Failed to load watchlist';
        notifyListeners();
      },
          (movies) {
        _watchlist = movies;
        _state = movies.isEmpty ? RequestState.empty : RequestState.success;
        notifyListeners();
      },
    );
  }

  /// Add or remove movie from watchlist (toggle)
  // Future<void> toggleWatchlist(Movie movie) async {
  //   final isAdded = _watchlist.any((m) => m.id == movie.id);
  //
  //   if (isAdded) {
  //     // Remove from watchlist
  //     await removeFromWatchlist(movie.id);
  //   } else {
  //     // Add to watchlist
  //     await addToWatchlist(movie);
  //   }
  // }

  /// Add or remove movie from watchlist (toggle)
  Future<void> toggleWatchlist(Movie movie) async {
    final isAdded = _watchlist.any((m) => m.id == movie.id);

    if (isAdded) {
      // Remove from watchlist
      final result = await removeFromWatchlist(movie.id);

      result.fold(
            (failure) {
          _error = 'Failed to remove from watchlist';
        },
            (success) {
          _watchlist.removeWhere((m) => m.id == movie.id);
          if (_watchlist.isEmpty) {
            _state = RequestState.empty;
          }
        },
      );
    } else {
      // Add to watchlist
      final result = await addToWatchlist(movie);

      result.fold(
            (failure) {
          _error = 'Failed to add to watchlist';
        },
            (success) {
          if (!_watchlist.any((m) => m.id == movie.id)) {
            _watchlist.add(movie);
            if (_state == RequestState.empty) {
              _state = RequestState.success;
            }
          }
        },
      );
    }

    notifyListeners(); // ← CRITICAL: Notify after changes
  }

  /// Check if movie is in watchlist
  bool isMovieInWatchlist(int movieId) {
    return _watchlist.any((m) => m.id == movieId);
  }

  /// Internal: Add movie
  Future<void> _addMovieToWatchlist(Movie movie) async {
    final result = await addToWatchlist(movie);

    result.fold(
          (failure) {
        _error = 'Failed to add to watchlist';
      },
          (success) {
        if (!_watchlist.any((m) => m.id == movie.id)) {
          _watchlist.add(movie);
          if (_state == RequestState.empty) {
            _state = RequestState.success;
          }
        }
      },
    );

    notifyListeners();
  }

  /// Internal: Remove movie
  Future<void> _removeMovieFromWatchlist(int movieId) async {
    final result = await removeFromWatchlist(movieId);

    result.fold(
          (failure) {
        _error = 'Failed to remove from watchlist';
      },
          (success) {
        _watchlist.removeWhere((m) => m.id == movieId);
        if (_watchlist.isEmpty) {
          _state = RequestState.empty;
        }
      },
    );

    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Storage error. Please try again.';
      default:
        return 'Unexpected error occurred.';
    }
  }
}