// lib/features/movies/presentation/pages/category_movies_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/request_state.dart';
import '../providers/category_movies_provider.dart';
import '../widgets/movie_card.dart';

class CategoryMoviesPage extends StatefulWidget {
  final MovieCategory category;
  final String title;

  const CategoryMoviesPage({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<CategoryMoviesPage> createState() => _CategoryMoviesPageState();
}

class _CategoryMoviesPageState extends State<CategoryMoviesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CategoryMoviesProvider>().loadMovies(widget.category);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // User is 200px from bottom, load next page
      context.read<CategoryMoviesProvider>().loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<CategoryMoviesProvider>(
        builder: (context, provider, child) {
          if (provider.state == RequestState.loading && provider.currentPage == 1) {
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
                  Text(provider.error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.refresh(),
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
                  Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No movies found'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: provider.movies.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.movies.length) {
                  // Loading indicator at bottom
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return MovieCard(movie: provider.movies[index]);
              },
            ),
          );
        },
      ),
    );
  }
}