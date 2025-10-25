// lib/features/movies/presentation/pages/movie_list_page.dart - UPDATED WITH THEME BUTTON

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/request_state.dart';
import '../../domain/entities/movie.dart';
import '../providers/movie_list_provider.dart';
import '../widgets/movie_category_list.dart';
import '../../../theme/presentation/providers/theme_provider.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../../injection_container.dart' as di;

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<MovieListProvider>().fetchAllMovies(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => di.sl<SearchProvider>(),
                    child: const SearchPage(),
                  ),
                ),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.pushNamed(context, '/watchlist');
            },
          ),
        ],
      ),
      body: Consumer<MovieListProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchAllMovies(),
            child: ListView(
              children: [
                _buildMovieSection(
                  context: context,
                  title: 'Now Playing',
                  state: provider.nowPlayingState,
                  movies: provider.nowPlayingMovies,
                  error: provider.nowPlayingError,
                  onRetry: provider.fetchNowPlayingMovies,
                ),
                _buildMovieSection(
                  context: context,
                  title: 'Popular',
                  state: provider.popularState,
                  movies: provider.popularMovies,
                  error: provider.popularError,
                  onRetry: provider.fetchPopularMovies,
                ),
                _buildMovieSection(
                  context: context,
                  title: 'Top Rated',
                  state: provider.topRatedState,
                  movies: provider.topRatedMovies,
                  error: provider.topRatedError,
                  onRetry: provider.fetchTopRatedMovies,
                ),
                _buildMovieSection(
                  context: context,
                  title: 'Upcoming',
                  state: provider.upcomingState,
                  movies: provider.upcomingMovies,
                  error: provider.upcomingError,
                  onRetry: provider.fetchUpcomingMovies,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection({
    required BuildContext context,
    required String title,
    required RequestState state,
    required List<Movie> movies,
    required String error,
    required VoidCallback onRetry,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (state == RequestState.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (state == RequestState.error)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (state == RequestState.empty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No movies found'),
              ),
            )
          else if (state == RequestState.success)
              MovieCategoryList(movies: movies),
      ],
    );
  }
}