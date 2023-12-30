import 'schedule.dart';
import 'package:http/http.dart' as http;

class Movie {
  final String name;
  final String? imageurl;
  final String originimage;
  final String language;
  final String status;
  final String year;
  final String runtime;
  final String genres;
  final String officialsite;
  final String type;
  final Schedule schedule;
  final String rating;
  final String summary;
  final String network;

  const Movie({
    required this.name,
    this.imageurl,
    required this.status,
    required this.year,
    required this.runtime,
    required this.language,
    required this.genres,
    required this.officialsite,
    required this.type,
    required this.schedule,
    required this.rating,
    required this.summary,
    required this.network,
    required this.originimage,
  });

  factory Movie.fromMap(Map<String, dynamic> json) {
    final schedule = Schedule(
        days: json["show"]["schedule"]["days"],
        time: json['show']['schedule']['time']);

    return Movie(
      name: json['show']['name'].toString(),
      imageurl: json["show"]["image"] != null
          ? json["show"]["image"]["medium"].toString()
          : "https://cdn.pixabay.com/photo/2019/11/07/20/48/cinema-4609877_1280.jpg",
      status: json['show']['status'].toString(),
      year: json["show"]["premiered"].toString(),
      runtime: json['show']['runtime'] != null
          ? json['show']['runtime'].toString()
          : '35',
      language: json['show']['language'].toString(),
      genres: json['show']['genres'][0],
      officialsite: json['show']['officialSite'].toString(),
      type: json['show']['type'].toString(),
      schedule: schedule,
      rating: json['show']['rating'] != null
          ? json['show']['rating']['average'].toString()
          : '7.6',
      summary: json['show']['summary'].toString(),
      network: json["show"]["network"] != null
          ? json["show"]["network"]["name"].toString()
          : 'America',
      originimage: json["show"]["image"] != null
          ? json["show"]["image"]["original"].toString()
          : "https://cdn.pixabay.com/photo/2019/11/07/20/48/cinema-4609877_1280.jpg",
    );
  }
}
