import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflix/widgets/filter_widget.dart';

import '../models/movie_model.dart';
import '../services/movie_api.dart';
import '../widgets/movie_list_item.dart';
import 'movie_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FeaturedMoviesScreen extends StatefulWidget {
  @override
  _FeaturedMoviesScreenState createState() => _FeaturedMoviesScreenState();
}

class _FeaturedMoviesScreenState extends State<FeaturedMoviesScreen> {
  List<Movie> movies = [];
  var moviecontroller = TextEditingController();
  Map<String, String?> selectedFilters = {}; // Store selected filters
  late ScrollController _scrollController;
  StreamSubscription? _gyroscopeSubscription;
  Timer? _scrollTimer;
  double tiltThreshold = 0.3; // Sensitivity: Lower = More Responsive
  double scrollSpeed = 50.0;

  void _openFilters() async {
    final filters = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FiltersWidget(),
    );

    if (filters != null) {
      setState(() {
        selectedFilters = filters; // Update filters when modal is closed
      });

      print("Selected Filters: $selectedFilters"); // Debugging log
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _scrollController = ScrollController();
    _startListeningToTilt();
  }

  void _startListeningToTilt() {
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      double tilt = event.y;

      // Stop previous scrolling when tilt is neutral
      if (tilt.abs() < tiltThreshold) {
        _scrollTimer?.cancel();
        return;
      }

      // Start scrolling in the correct direction
      _scrollTimer?.cancel();
      _scrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        double newOffset =
            _scrollController.offset + (tilt > 0 ? scrollSpeed : -scrollSpeed);

        // Ensure we don't scroll beyond list limits
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          );
        }
      });
    });
  }

  Future<void> fetchMovies() async {
    final response = await MovieApi.fetchMovies();
    setState(() {
      movies = response;
    });
  }

  void searchMovie(String query) {
    final suggestions = movies.where((movie) {
      final name = movie.name.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    setState(() {
      movies = suggestions;
    });
  }

  @override
  void dispose() {
    moviecontroller.dispose();
    _gyroscopeSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: 1,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 255, 232, 240),
                        hintText: 'Search Movies',
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        icon: Icon(
                          Icons.search,
                          size: 30,
                          color: Color.fromARGB(255, 0, 21, 37),
                        ),
                      ),
                      controller: moviecontroller,
                      onChanged: (value) {
                        if (movies.isEmpty) {
                          fetchMovies();
                        } else if (moviecontroller.text.isEmpty) {
                          fetchMovies();
                        } else {
                          searchMovie(moviecontroller.text);
                        }
                      },
                      onSubmitted: (value) {
                        if (moviecontroller.text.isEmpty) {
                          fetchMovies();
                        } else if (movies.isEmpty) {
                          fetchMovies();
                          moviecontroller.text = '';
                        } else {
                          searchMovie(moviecontroller.text);
                          moviecontroller.text = '';
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter Icon Button
                  IconButton(
                    icon: const Icon(Icons.filter_list,
                        size: 30, color: Colors.red),
                    onPressed: () {
                      _openFilters();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'Featured Movies',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              // Now using ListView.builder for the movies list
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: movies.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final movie = movies[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => MovieScreen(movie: movie)));
                      },
                      child: MovieListItem(
                        imageUrl: movie.imageurl!,
                        name: movie.name,
                        information:
                            '${movie.status} | ${movie.type} | ${movie.genres} | ${movie.runtime}min |  ⭐ ${movie.rating} ',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
