import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/request_state.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../providers/search_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  bool showClearSearchIcon=false;


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),

          style: TextStyle(color: Colors.white),
          onChanged: (query) {
            context.read<SearchProvider>().search(query);
            setState(() {
              showClearSearchIcon=_searchController.text.isNotEmpty;
            });
          },
        ),
        actions: [
            if (showClearSearchIcon)
                 IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchProvider>().clearSearch();
                    setState(() {
                      showClearSearchIcon=_searchController.text.isNotEmpty;
                    });
                  },
                )



        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.state == RequestState.empty &&
              provider.currentQuery.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Search for movies',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter a movie title to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

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
                  Text(provider.error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (provider.currentQuery.isNotEmpty) {
                        provider.search(provider.currentQuery);
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.state == RequestState.empty &&
              provider.currentQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_filter_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No movies found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try a different search term',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
            itemCount: provider.results.length,
            itemBuilder: (context, index) {
              return Center(child: MovieCard(movie: provider.results[index]));
            },
          );
        },
      ),
    );
  }
}
