import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the movie details screen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Container(
          width: 150.0, // Fixed width for the card
          height: 250.0, // Fixed height for the card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Movie Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                  height: 150.0, // Fixed height for image
                  width: 150.0,  // Fixed width for image
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.0),
              // Movie Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  movie.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,  // Only one line for the title
                  overflow: TextOverflow.ellipsis, // Truncate long titles
                  textAlign: TextAlign.center, // Center the title
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
