import 'dart:convert';
import 'package:flutterflix/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieApi {
  static Future<List<Movie>> fetchMovies() async {
    const url = 'https://api.tvmaze.com/search/shows?q=all';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    final List<dynamic> results = jsonDecode(response.body);
    final movies = results.map((json) {
      return Movie.fromMap(json);
    }).toList();
    return movies;
  }

  void searchMovie(String query) {}
}
