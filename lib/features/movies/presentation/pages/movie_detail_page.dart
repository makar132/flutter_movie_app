// lib/features/movies/presentation/pages/movie_detail_page.dart - UPDATED WITH WATCHLIST

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/movie.dart';
import '../../../watchlist/presentation/providers/watchlist_provider.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          Consumer<WatchlistProvider>(
            builder: (context, watchlistProvider, child) {
              final isInWatchlist =
              watchlistProvider.isMovieInWatchlist(movie.id);

              return IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWatchlist ? Colors.red : null,
                ),
                onPressed: () {
                  watchlistProvider.toggleWatchlist(movie);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isInWatchlist
                            ? 'Removed from watchlist'
                            : 'Added to watchlist',
                      ),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backdrop Image
            if (movie.backdropPath.isNotEmpty)
              Image.network(
                '${AppConstants.backdropBaseUrl}${movie.backdropPath}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.error, size: 48),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating & Release Date
                  Row(
                    children: [
                      if (movie.voteAverage > 0) ...[
                        const Icon(Icons.star,
                            color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.voteAverage.toStringAsFixed(1)}/10',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (movie.releaseDate.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            movie.releaseDate,
                            style:
                            Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Overview Title
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Overview Text
                  Text(
                    movie.overview,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  // Poster Image
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        '${AppConstants.imageBaseUrl}${movie.posterPath}',
                        width: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 300,
                            color: Colors.grey,
                            child: const Icon(Icons.error, size: 48),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}