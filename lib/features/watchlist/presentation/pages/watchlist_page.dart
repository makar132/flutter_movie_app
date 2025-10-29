import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/request_state.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../providers/watchlist_provider.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
          () => context.read<WatchlistProvider>().loadWatchlist(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
      ),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, child) {
          if (provider.state == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                    onPressed: () => provider.loadWatchlist(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.state == RequestState.empty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No movies in watchlist',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Add movies from the home page',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: provider.watchlist.length,
            itemBuilder: (context, index) {
              return Center(
                child:
                  MovieCard(movie: provider.watchlist[index]),

              );
            },
          );
        },
      ),
    );
  }
}