import 'package:flutter/material.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    if (movieProvider.watchlist.isEmpty) {
      return Center(child: Text('No movies in watchlist'));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your Watchlist')),
      body: ListView.builder(
        itemCount: movieProvider.watchlist.length,
        itemBuilder: (context, index) {
          final movie = movieProvider.watchlist[index];
          return ListTile(
            title: Text(movie.title),
            leading: Image.network(
              'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
              width: 50,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
