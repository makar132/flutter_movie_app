import 'package:flutter/material.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/widgets/movie_card.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    if (movieProvider.nowPlaying.isEmpty) {
      debugPrint("provider : ${movieProvider.popular}");
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            icon: Icon(movieProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              movieProvider.toggleTheme();
            },
          )
        ],
      ),
      body: ListView(
        children: [
          MovieCategoryList(category: 'Now Playing', movies: movieProvider.nowPlaying),
          MovieCategoryList(category: 'Popular', movies: movieProvider.popular),
          MovieCategoryList(category: 'Top Rated', movies: movieProvider.topRated),
          MovieCategoryList(category: 'Upcoming', movies: movieProvider.upcoming),
        ],
      ),
    );
  }
}

class MovieCategoryList extends StatelessWidget {
  final String category;
  final List<Movie> movies;

  const MovieCategoryList({super.key, required this.category, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(category, style: Theme.of(context).textTheme.titleLarge),
        ),
        // Use ListView with shrinkWrap enabled for dynamic sizing
        SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true, // Ensures the ListView only takes the required space
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}
