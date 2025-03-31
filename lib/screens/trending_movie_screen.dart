import 'package:flutter/material.dart';

import '../models/movie_model.dart';
import '../services/movie_api.dart';
import '../widgets/movie_list_item.dart';
import 'movie_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TrendingMovieScreen extends StatefulWidget {
  const TrendingMovieScreen({super.key});

  @override
  State<TrendingMovieScreen> createState() => _TrendingMovieScreenState();
}

class _TrendingMovieScreenState extends State<TrendingMovieScreen> {
  List<Movie> trendingmovies = [];
  String countrycode = '';
  var moviecontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
  }

  Future<void> fetchTrendingMovies() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
      }

      // Get the user's location
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);

      // Reverse geocode to get country name
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String country = placemarks.first.country ?? "US"; // Default to US
        String countryCode = _mapCountryToCode(country);

        final response = await MovieApi.fetchTrendingMovies(countryCode);
        setState(() {
          trendingmovies = response;
        });
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

// Function to map country name to country code
  String _mapCountryToCode(String country) {
    Map<String, String> countryCodes = {
      "United States": "US",
      "India": "IN",
      "United Kingdom": "GB",
      "Canada": "CA",
      "Australia": "AU",
      "Germany": "DE",
      "France": "FR",
      "Japan": "JP",
      "China": "CN",
      "Brazil": "BR",
    };
    return countryCodes[country] ?? "US"; // Default to US if not found
  }

  void searchMovie(String query) {
    final suggestions = trendingmovies.where((movie) {
      final name = movie.name.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    setState(() {
      trendingmovies = suggestions;
    });
  }

  @override
  void dispose() {
    moviecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 1,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(255, 255, 232, 240),
                  hintText: 'Search Movies',
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Color.fromARGB(255, 0, 21, 37),
                  ),
                ),
                controller: moviecontroller,
                onChanged: (value) {
                  if (trendingmovies.isEmpty) {
                    fetchTrendingMovies();
                  } else if (moviecontroller.text.isEmpty) {
                    fetchTrendingMovies();
                  } else {
                    searchMovie(moviecontroller.text);
                  }
                },
                onSubmitted: (value) {
                  if (moviecontroller.text.isEmpty) {
                    fetchTrendingMovies();
                  } else if (trendingmovies.isEmpty) {
                    fetchTrendingMovies();
                    moviecontroller.text = '';
                  } else {
                    searchMovie(moviecontroller.text);
                    moviecontroller.text = '';
                  }
                },
              ),
              const SizedBox(height: 25),
              Text(
                'Trending Shows in India',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              // Now using ListView.builder for the movies list
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: trendingmovies.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final movie = trendingmovies[index];
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
