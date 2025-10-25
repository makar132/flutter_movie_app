// lib/features/movies/domain/usecases/movie_params.dart

import 'package:equatable/equatable.dart';

class MovieParams extends Equatable {
  final int page;

  const MovieParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}