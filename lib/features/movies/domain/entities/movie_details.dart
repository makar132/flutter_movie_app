import 'package:equatable/equatable.dart';
import 'movie.dart';

class Cast extends Equatable {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  @override
  List<Object?> get props => [id, name, character, profilePath];
}

class Video extends Equatable {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  const Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  // String get youtubeUrl => 'https://www.youtube.com/embed/$key';

  @override
  List<Object?> get props => [id, key, name, site, type];
}

class MovieDetails extends Equatable {
  final Movie baseMovie;
  final List<Cast> cast;
  final List<Video> videos;
  final List<Movie> similarMovies;
  final String? runtime;
  final String? budget;
  final String? revenue;

  const MovieDetails({
    required this.baseMovie,
    required this.cast,
    required this.videos,
    required this.similarMovies,
    this.runtime,
    this.budget,
    this.revenue,
  });

  @override
  List<Object?> get props => [
    baseMovie,
    cast,
    videos,
    similarMovies,
    runtime,
    budget,
    revenue,
  ];
}