import 'package:flutter/material.dart';
import 'package:movie_app/network/remote/api_manager.dart';

class MyProvider with ChangeNotifier {
  final ApiManager _apiManager = ApiManager();

  List<dynamic> trendingMovies = [];
  List<dynamic> nowPlayingMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> onAirTvSeries = [];
  List<dynamic> popularTvSeries = [];
  List<dynamic> topRatedTvSeries = [];
  List<dynamic> cast = [];
  bool isLoading = true;
  String? errorMessage;

  // Fetch trending movies for the week
 Future<void> fetchTrendingMoviesWeek() async {
  try {
    isLoading = true;
    notifyListeners(); // Notify listeners before clearing the list
    trendingMovies = []; // Clear the list before fetching new data
    notifyListeners(); // Notify listeners again to reflect the cleared list
    trendingMovies = await _apiManager.getTrendingMovies('week');
    isLoading = false;
    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    isLoading = false;
    notifyListeners();
  }
}

Future<void> fetchTrendingMoviesDay() async {
  try {
    isLoading = true;
    notifyListeners(); // Notify listeners before clearing the list
    trendingMovies = []; // Clear the list before fetching new data
    notifyListeners(); // Notify listeners again to reflect the cleared list
    trendingMovies = await _apiManager.getTrendingMovies('day');
    isLoading = false;
    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    isLoading = false;
    notifyListeners();
  }
}
  // Fetch now playing movies
  Future<void> fetchNowPlayingMovies() async {
    try {
      isLoading = true;
      notifyListeners();
      nowPlayingMovies = await _apiManager.getNowPlayingMovies();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch top-rated movies
  Future<void> fetchTopRatedMovies() async {
    try {
      isLoading = true;
      notifyListeners();
      topRatedMovies = await _apiManager.getTopRatedMovies();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch upcoming movies
  Future<void> fetchUpcomingMovies() async {
    try {
      isLoading = true;
      notifyListeners();
      upcomingMovies = await _apiManager.getUpcomingMovies();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch on-air TV series
  Future<void> fetchOnAirTvSeries() async {
    try {
      isLoading = true;
      notifyListeners();
      onAirTvSeries = await _apiManager.getOnAirTvSeries();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch popular TV series
  Future<void> fetchPopularTvSeries() async {
    try {
      isLoading = true;
      notifyListeners();
      popularTvSeries = await _apiManager.getPopularTvSeries();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch top-rated TV series
  Future<void> fetchTopRatedTvSeries() async {
    try {
      isLoading = true;
      notifyListeners();
      topRatedTvSeries = await _apiManager.getTopRatedTvSeries();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch cast for a movie or TV show
  Future<List<dynamic>> getCast(int id, String mediaType) async {
    try {
      isLoading = true;
      notifyListeners(); // Notify listeners that loading has started

      // Fetch data
      cast = await _apiManager.getCast(id, mediaType);

      isLoading = false;
      notifyListeners(); // Notify listeners that loading is complete
      return cast; // Return the cast list
    } catch (e) {
      isLoading = false;
      notifyListeners(); // Notify listeners in case of an error
      // ignore: use_rethrow_when_possible
      throw e; // Re-throw the error
    }
  }
}