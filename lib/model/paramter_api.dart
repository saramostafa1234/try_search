class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String posterPath;
  List<String> mainCharacters;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.posterPath,
    required this.mainCharacters,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '...',
      releaseDate: json['release_date'] ?? '',
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      mainCharacters: [],
    );
  }
}
