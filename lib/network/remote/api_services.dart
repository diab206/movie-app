import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_app/apikey/api_key.dart';

class ApiService {
  static const String _baseUrl = "https://api.themoviedb.org/3";

  // Generic function to fetch data from API
  static Future<dynamic> fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  // Fetch Trending Movies (Daily or Weekly)
  static Future<List<dynamic>> getTrendingMovies(String timeWindow) async {
    final data = await fetchData("$_baseUrl/trending/movie/$timeWindow?api_key=$aPIKey");
    return data["results"];
  }

  // Fetch Now Playing Movies
  static Future<List<dynamic>> getNowPlayingMovies() async {
    final data = await fetchData("$_baseUrl/movie/now_playing?api_key=$aPIKey&language=en-US&page=1");
    return data["results"];
  }

  // Fetch Top Rated Movies
  static Future<List<dynamic>> getTopRatedMovies() async {
    final data = await fetchData("$_baseUrl/movie/top_rated?api_key=$aPIKey&language=en-US&page=1");
    return data["results"];
  }

  // Fetch Upcoming Movies
  static Future<List<dynamic>> getUpcomingMovies() async {
    final data = await fetchData("$_baseUrl/movie/upcoming?api_key=$aPIKey&language=en-US&page=1");
    return data["results"];
  }

  // Fetch Popular TV Series
  static Future<List<dynamic>> getPopularTvSeries() async {
    final data = await fetchData("$_baseUrl/tv/popular?api_key=$aPIKey&language=en-US&page=1");
    return data["results"];
  }

  // Fetch Top Rated TV Series
  static Future<List<dynamic>> getTopRatedTvSeries() async {
    final data = await fetchData("$_baseUrl/tv/top_rated?api_key=$aPIKey&language=en-US&page=1");
    return data["results"];
  }

  // Fetch On-Air TV Series
  static Future<List<dynamic>> getOnAirTvSeries() async {
    final data = await fetchData("$_baseUrl/tv/on_the_air?api_key=$aPIKey&language=en-US&page=1");
    return data["results"];
  }

  // Fetch Movie or TV Show Details by ID
  static Future<Future> getDetails(int id, String type) async {
    return fetchData("$_baseUrl/$type/$id?api_key=$aPIKey&language=en-US");
  }


  // Fetch Similar Movies or TV Shows
  static Future<List<dynamic>> getSimilar(int id, String type) async {
    final data = await fetchData("$_baseUrl/$type/$id/similar?api_key=$aPIKey");
    return data["results"];
  }
   static Future<List<dynamic>> getCast(int id, String type) async {
    final data = await fetchData("$_baseUrl/$type/$id/credits?api_key=$aPIKey");
    return data["cast"] ?? [];
  }
  static Future<List<dynamic>> searchMoviesAndTv(String query) async {
    final data = await fetchData("$_baseUrl/search/multi?api_key=$aPIKey&query=$query");
    return data["results"] ?? [];
  }
}

