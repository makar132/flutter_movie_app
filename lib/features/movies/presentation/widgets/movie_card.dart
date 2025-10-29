import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/presentation/providers/movie_detail_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/movie.dart';
import '../../../watchlist/presentation/providers/watchlist_provider.dart';
import '../pages/movie_detail_page.dart';
import '../../../../injection_container.dart' as di;

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => di.sl<MovieDetailProvider>(),
              child: MovieDetailPage(movie: movie),
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: SizedBox(
          width: 200.0,
          height: 300.0,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Movie Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      '${AppConstants.imageBaseUrl}${movie.posterPath}',
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200.0,
                          width: 200.0,
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.white),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 200.0,
                          width: 200.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Movie Title
                  Expanded(
                    child: Center(
                      child: Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              // Watchlist Button
              Positioned(
                top: 4,
                right: 4,
                child: Consumer<WatchlistProvider>(
                  builder: (context, watchlistProvider, child) {
                    final isInWatchlist = watchlistProvider.isMovieInWatchlist(
                      movie.id,
                    );

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                        icon: Icon(
                          isInWatchlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isInWatchlist ? Colors.red : Colors.white,
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
