import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutterflix/models/movie_model.dart';
import 'package:flutterflix/widgets/movie_list_item.dart';
import 'movie_screen.dart'; // Ensure this file exists

class ClassicMoviesScreen extends StatefulWidget {
  @override
  _ClassicMoviesScreenState createState() => _ClassicMoviesScreenState();
}

class _ClassicMoviesScreenState extends State<ClassicMoviesScreen> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    String jsonString = await rootBundle.loadString('assets/Film.JSON');
    List<dynamic> jsonList = json.decode(jsonString);

    setState(() {
      movies = jsonList.map((json) => Movie.fromJson2(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return movies.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              final movie = movies[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MovieScreen(movie: movie)));
                  },
                  child: MovieListItem(
                    imageUrl: movie.imageurl ?? '',
                    name: movie.name,
                    information:
                        '${movie.status} | ${movie.type} | ${movie.genres} | ${movie.runtime} | ⭐ ${movie.rating} ',
                  ),
                ),
              );
            },
          );
  }
}
