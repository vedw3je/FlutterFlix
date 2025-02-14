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
      days: (json["schedule"] != null && json["schedule"]["days"] != null)
          ? json["schedule"]["days"]
          : ['Sunday'], // Default to ['Sunday'] if schedule or days is null
      time: (json["schedule"] != null && json['schedule']['time'] != null)
          ? json['schedule']['time']
          : '', // Default to empty string if time is null
    );

    return Movie(
      name: json['name'].toString(),
      imageurl: json["image"] != null
          ? json["image"]["medium"].toString()
          : "https://cdn.pixabay.com/photo/2019/11/07/20/48/cinema-4609877_1280.jpg",
      status: json['status'].toString(),
      year: json["premiered"].toString(),
      runtime: json['runtime'] != null ? json['runtime'].toString() : '35',
      language: json['language'].toString(),
      genres: json['genres'] != null && json['genres'].isNotEmpty
          ? json['genres'][0]
          : 'Unknown', // Default value if the genres list is empty or null
      officialsite: json['officialSite'].toString(),
      type: json['type'].toString(),
      schedule: schedule,
      rating:
          json['rating'] != null ? json['rating']['average'].toString() : '7.6',
      summary: json['summary'].toString(),
      network: json["network"] != null
          ? json["network"]["name"].toString()
          : 'America',
      originimage: json["image"] != null
          ? json["image"]["original"].toString()
          : "https://cdn.pixabay.com/photo/2019/11/07/20/48/cinema-4609877_1280.jpg",
    );
  }
}
