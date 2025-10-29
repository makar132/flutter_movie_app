import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieCategoryList extends StatelessWidget {
  final List<Movie> movies;

  const MovieCategoryList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}