class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;      // NEW - added
  final double voteAverage;       // NEW - added
  final String releaseDate;       // NEW - added
  final List<int> genreIds;       // NEW - added

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });
}