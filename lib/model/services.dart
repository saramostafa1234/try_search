import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:try_screen_search/model/paramter_api.dart';

class ApiService {
  static Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=e4ab5208166d93d4007c48e60d11d7e1&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      List<Movie> movies = [];

      for (var movieData in results) {
        Movie movie = Movie.fromJson(movieData);

        List<String> mainCharacters =
            await fetchMainCharacters(movieData['id']);
        movie.mainCharacters = mainCharacters;

        movies.add(movie);
      }
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<String>> fetchMovieSuggestions(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=e4ab5208166d93d4007c48e60d11d7e1&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map<String>((movie) => movie['title'] as String).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  static Future<List<String>> fetchMainCharacters(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=e4ab5208166d93d4007c48e60d11d7e1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List cast = data['cast'];

      List<String> mainCharacters = [];
      for (int i = 0; i < cast.length && i < 3; i++) {
        mainCharacters.add(cast[i]['name']);
      }

      return mainCharacters;
    } else {
      throw Exception('Failed to load main characters');
    }
  }
}
