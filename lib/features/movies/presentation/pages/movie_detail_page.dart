import 'package:flutter/material.dart';
import 'package:movie_app/core/utils/youtube_launcher.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/request_state.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/movie.dart';
import '../providers/movie_detail_provider.dart';
import '../../../watchlist/presentation/providers/watchlist_provider.dart';
import '../../../../injection_container.dart' as di;

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MovieDetailProvider>().loadMovieDetails(widget.movie.id);

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailProvider>(
        builder: (context, provider, _) {
          if (provider.state == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == RequestState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MovieDetailProvider>().loadMovieDetails(
                        widget.movie.id,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final details = provider.movieDetails;
          if (details == null) {
            return const Center(child: Text('No data available'));
          }

          return CustomScrollView(
            slivers: [
              // App Bar with poster
              SliverAppBar(
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        '${AppConstants.imageBaseUrl}${details.baseMovie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Consumer<WatchlistProvider>(
                    builder: (context, watchlistProvider, child) {
                      final isInWatchlist = watchlistProvider
                          .isMovieInWatchlist(widget.movie.id);
                      return IconButton(
                        icon: Icon(
                          isInWatchlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isInWatchlist ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          watchlistProvider.toggleWatchlist(widget.movie);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isInWatchlist
                                    ? 'Removed from watchlist'
                                    : 'Added to watchlist',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              // Movie Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  details.baseMovie.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${details.baseMovie.voteAverage.toStringAsFixed(1)}/10',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(width: 16),
                                    if (details.runtime != null)
                                      Text(
                                        details.runtime!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Budget and Revenue
                      if (details.budget != null || details.revenue != null)
                        Wrap(
                          spacing: 16,
                          children: [
                            if (details.budget != null)
                              _InfoChip(
                                label: 'Budget',
                                value: details.budget!,
                              ),
                            if (details.revenue != null)
                              _InfoChip(
                                label: 'Revenue',
                                value: details.revenue!,
                              ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Overview
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(details.baseMovie.overview),
                    ],
                  ),
                ),
              ),

              // Cast Section
              if (details.cast.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Cast',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: details.cast.length,
                            itemBuilder: (context, index) {
                              final actor = details.cast[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: actor.profilePath != null
                                          ? Image.network(
                                              '${AppConstants.imageBaseUrl}${actor.profilePath}',
                                              width: 100,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 100,
                                              height: 140,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(Icons.person),
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            actor.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              height: 1.2,
                                            ),
                                          ),
                                          Text(
                                            actor.character,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Trailers Section
              if (details.videos.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Trailers & Videos',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...details.videos.map((video) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.primaryContainer,
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.play_circle,
                                  color: Colors.red,
                                ),
                                title: Text(video.name),
                                trailing: const Icon(Icons.open_in_new, size: 20),
                                onTap: () async{
                                  await YoutubeLauncher.launchVideoSafe(
                                    video.key,
                                    onError: (error){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

              // Similar Movies Section
              if (details.similarMovies.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Similar Movies',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: details.similarMovies.length,
                            itemBuilder: (context, index) {
                              final similarMovie = details.similarMovies[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                              create: (_) =>
                                                  di.sl<MovieDetailProvider>(),
                                              child: MovieDetailPage(
                                                movie: similarMovie,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      '${AppConstants.imageBaseUrl}${similarMovie.posterPath}',
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
