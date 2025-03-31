import 'dart:convert';

import 'package:flutterflix/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieApi {
  static Future<List<Movie>> fetchMovies() async {
    const url = 'https://api.tvmaze.com/shows';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);
        return results.map((json) => Movie.fromMap(json)).toList();
      } else {
        throw Exception(
            "Failed to load movies. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }

  static Future<List<Movie>> fetchTrendingMovies(String countryCode) async {
    final String url =
        'https://api.tvmaze.com/schedule/web?date=2020-05-29&country=$countryCode';
    final Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);
        return results.map((json) => Movie.fromMap(json)).toList();
      } else {
        throw Exception(
            "Failed to load trending movies. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching trending movies: $e");
      return [];
    }
  }
}
