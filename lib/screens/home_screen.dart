import 'package:flutter/material.dart';
import 'movie_screen.dart';
import '../services/movie_api.dart';
import '../models/movie_model.dart';
import '../widgets/movie_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  var movie = [];
  final moviecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchmovies();
    moviecontroller;
  }

  Future<void> fetchmovies() async {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 253, 255),
      appBar: AppBar(
        actions: [],
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 2.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 0, 38, 82),
            child: Center(
              child: Text(
                'Explore',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 140,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldTapRegion(
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
                          fetchmovies();
                        } else if (moviecontroller.text.isEmpty) {
                          fetchmovies();
                        } else {
                          searchMovie(moviecontroller.text);
                        }
                      },
                      onSubmitted: (value) {
                        if (moviecontroller.text.isEmpty) {
                          fetchmovies();
                        } else if (movies.isEmpty) {
                          fetchmovies();
                          moviecontroller.text = '';
                        } else {
                          searchMovie(moviecontroller.text);
                          moviecontroller.text = '';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge,
                      children: [
                        TextSpan(
                          text: 'Featured ',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: 'Movies',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final movie in movies)
                    InkWell(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 25);
    path.quadraticBezierTo(width / 2, height, width, height - 20);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
