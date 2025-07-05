import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app/apikey/api_key.dart';

class ApiManager {
  final String baseUrl = "https://api.themoviedb.org/3";

  // Generic function to fetch data from API
  Future<List<dynamic>> _fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'];
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  // Fetch Trending Movies (Daily or Weekly)
  Future<List<dynamic>> getTrendingMovies(String timeWindow) async {
    final url = "$baseUrl/trending/movie/$timeWindow?api_key=$aPIKey";
    return _fetchData(url);
  }

  // Fetch Now Playing Movies
  Future<List<dynamic>> getNowPlayingMovies() async {
    final url = "$baseUrl/movie/now_playing?api_key=$aPIKey&language=en-US&page=1";
    return _fetchData(url);
  }

  // Fetch Top Rated Movies
  Future<List<dynamic>> getTopRatedMovies() async {
    final url = "$baseUrl/movie/top_rated?api_key=$aPIKey&language=en-US&page=1";
    return _fetchData(url);
  }

  // Fetch Popular TV Series
  Future<List<dynamic>> getPopularTvSeries() async {
    final url = "$baseUrl/tv/popular?api_key=$aPIKey&language=en-US&page=1";
    return _fetchData(url);
  }

  // Fetch Top Rated TV Series
  Future<List<dynamic>> getTopRatedTvSeries() async {
    final url = "$baseUrl/tv/top_rated?api_key=$aPIKey&language=en-US&page=1";
    return _fetchData(url);
  }

  // Fetch Upcoming Movies
  Future<List<dynamic>> getUpcomingMovies() async {
    final url = "$baseUrl/movie/upcoming?api_key=$aPIKey&language=en-US&page=1";
    return _fetchData(url);
  }

  // Fetch On-Air TV Series
  Future<List<dynamic>> getOnAirTvSeries() async {
    final url = "$baseUrl/tv/on_the_air?api_key=$aPIKey&language=en-US&page=1";
    return _fetchData(url);
  }

  // Fetch Cast
  Future<List<dynamic>> getCast(int id, String type) async {
    final url = "$baseUrl/$type/$id/credits?api_key=$aPIKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'] ?? [];
    }
    throw Exception("Failed to load cast");
  }

  // Search Movies and TV Shows
  Future<List<dynamic>> searchMoviesAndTv(String query) async {
    final url = "$baseUrl/search/multi?api_key=$aPIKey&query=$query";
    return _fetchData(url);
  }
}