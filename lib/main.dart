import 'package:flutter/material.dart';
import 'package:movie_app/providers/movie_provider.dart';
import 'package:movie_app/screens/movie_list_screen.dart';
import 'package:movie_app/screens/watchlist_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider()..loadTheme()..fetchMovies(),
      child: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie App',
            theme: movieProvider.isDarkMode
                ? ThemeData.dark().copyWith(
              appBarTheme: AppBarTheme(backgroundColor: Colors.black),
            )
                : ThemeData.light().copyWith(
              appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
            ),
            home: MovieListScreen(),
            routes: {
              '/watchlist': (context) => WatchlistScreen(),
            },
          );
        },
      ),
    );
  }
}
