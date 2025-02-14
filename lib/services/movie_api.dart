import 'dart:convert';
import 'package:flutterflix/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieApi {
  static Future<List<Movie>> fetchMovies() async {
    const url = 'https://api.tvmaze.com/shows';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    final List<dynamic> results = jsonDecode(response.body);
    final movies = results.map((json) {
      return Movie.fromMap(json);
    }).toList();
    return movies;
  }

  static Future<List<Movie>> fetchTrendingMovies() async {
    const url =
        'https://api.tvmaze.com/schedule/web?date=2020-05-29&country=IN';
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
