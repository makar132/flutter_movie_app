// lib/injection_container.dart - UPDATED WITH WATCHLIST

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';

// Movies imports
import 'features/movies/data/datasources/movie_remote_data_source.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/get_now_playing_movies.dart';
import 'features/movies/domain/usecases/get_popular_movies.dart';
import 'features/movies/domain/usecases/get_top_rated_movies.dart';
import 'features/movies/domain/usecases/get_upcoming_movies.dart';
import 'features/movies/presentation/providers/movie_list_provider.dart';

// Theme imports
import 'features/theme/data/datasources/theme_local_data_source.dart';
import 'features/theme/data/repositories/theme_repository_impl.dart';
import 'features/theme/domain/repositories/theme_repository.dart';
import 'features/theme/domain/usecases/get_theme.dart';
import 'features/theme/domain/usecases/set_theme.dart';
import 'features/theme/presentation/providers/theme_provider.dart';

// Watchlist imports
import 'features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'features/watchlist/domain/repositories/watchlist_repository.dart';
import 'features/watchlist/domain/usecases/add_to_watchlist.dart';
import 'features/watchlist/domain/usecases/get_watchlist.dart';
import 'features/watchlist/domain/usecases/is_in_watchlist.dart';
import 'features/watchlist/domain/usecases/remove_from_watchlist.dart';
import 'features/watchlist/presentation/providers/watchlist_provider.dart';

//Search imports
import 'features/search/data/datasources/search_remote_data_source.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_movies.dart';
import 'features/search/presentation/providers/search_provider.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // ========== MOVIES FEATURE ==========

  // Providers
  sl.registerFactory(
        () => MovieListProvider(
      getNowPlayingMovies: sl(),
      getPopularMovies: sl(),
      getTopRatedMovies: sl(),
      getUpcomingMovies: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNowPlayingMovies(sl()));
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetTopRatedMovies(sl()));
  sl.registerLazySingleton(() => GetUpcomingMovies(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
        () => MovieRemoteDataSourceImpl(dio: sl()),
  );

  // ========== THEME FEATURE ==========

  // Providers
  sl.registerFactory(
        () => ThemeProvider(
      getTheme: sl(),
      setTheme: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTheme(sl()));
  sl.registerLazySingleton(() => SetTheme(sl()));

  // Repository
  sl.registerLazySingleton<ThemeRepository>(
        () => ThemeRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ThemeLocalDataSource>(
        () => ThemeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ========== WATCHLIST FEATURE ==========

  // Providers
  sl.registerFactory(
        () => WatchlistProvider(
      getWatchlist: sl(),
      addToWatchlist: sl(),
      removeFromWatchlist: sl(),
      isInWatchlist: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetWatchlist(sl()));
  sl.registerLazySingleton(() => AddToWatchlist(sl()));
  sl.registerLazySingleton(() => RemoveFromWatchlist(sl()));
  sl.registerLazySingleton(() => IsInWatchlist(sl()));

  // Repository
  sl.registerLazySingleton<WatchlistRepository>(
        () => WatchlistRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<WatchlistLocalDataSource>(
        () => WatchlistLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ========== CORE ==========

  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl()),
  );

  // ========== EXTERNAL ==========

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ========== SEARCH FEATURE ==========

  // Providers
  sl.registerFactory(
        () => SearchProvider(
      searchMovies: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SearchMovies(sl()));

  // Repository
  sl.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(dio: sl()),
  );
}