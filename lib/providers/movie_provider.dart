import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Movie> nowPlaying = [];
  List<Movie> popular = [];
  List<Movie> topRated = [];
  List<Movie> upcoming = [];
  List<Movie> watchlist = [];
  bool isDarkMode = false;

  // Fetch movie data
  Future<void> fetchMovies() async {
    try {
      nowPlaying = await _apiService.fetchMovies('now_playing');
      popular = await _apiService.fetchMovies('popular');
      topRated = await _apiService.fetchMovies('top_rated');
      upcoming = await _apiService.fetchMovies('upcoming');
      notifyListeners();
    } catch (e) {
      print("Error fetching movies: ${e.toString()}");
    }
  }

  // Toggle watchlist
  void toggleWatchlist(Movie movie) {
    if (watchlist.contains(movie)) {
      watchlist.remove(movie);
    } else {
      watchlist.add(movie);
    }
    _saveWatchlist();
    notifyListeners();
  }

  // Load watchlist from SharedPreferences
  Future<void> loadWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedWatchlist = prefs.getStringList('watchlist') ?? [];
    watchlist = savedWatchlist.map((id) => Movie(id: int.parse(id), title: '', overview: '', posterPath: '')).toList();
  }

  // Save watchlist to SharedPreferences
  Future<void> _saveWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchlistIds = watchlist.map((movie) => movie.id.toString()).toList();
    prefs.setStringList('watchlist', watchlistIds);
  }

  // Toggle dark/light theme
  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  // Load theme from SharedPreferences
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
