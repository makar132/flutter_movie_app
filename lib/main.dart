import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/movies/presentation/pages/movie_list_page.dart';
import 'features/movies/presentation/providers/movie_list_provider.dart';
import 'features/theme/presentation/providers/theme_provider.dart';
import 'features/watchlist/presentation/pages/watchlist_page.dart';
import 'features/watchlist/presentation/providers/watchlist_provider.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<ThemeProvider>()..loadTheme(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<MovieListProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<WatchlistProvider>()..loadWatchlist(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie App',
            theme: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const MovieListPage(),
            routes: {
              '/watchlist': (context) => const WatchlistPage(),
            },
          );
        },
      ),
    );
  }
}