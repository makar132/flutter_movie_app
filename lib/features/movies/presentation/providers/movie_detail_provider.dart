import 'package:flutter/foundation.dart';
import '../../../../core/enums/request_state.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/usecases/get_movie_details.dart';

class MovieDetailProvider extends ChangeNotifier {
  final GetMovieDetails getMovieDetails;

  MovieDetailProvider({required this.getMovieDetails});

  MovieDetails? _movieDetails;
  MovieDetails? get movieDetails => _movieDetails;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _error = '';
  String get error => _error;

  Future<void> loadMovieDetails(int movieId) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getMovieDetails(movieId);

    result.fold(
          (failure) {
        _state = RequestState.error;
        _error = _mapFailureToMessage(failure);
        notifyListeners();
      },
          (details) {
        _movieDetails = details;
        _state = RequestState.success;
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