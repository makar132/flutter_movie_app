import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Poster
              Center(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                  width: 200,
                ),
              ),
              SizedBox(height: 16),

              // Movie Title
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),

              // Movie Overview
              Text(
                movie.overview,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
