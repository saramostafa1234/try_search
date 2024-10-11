import 'package:flutter/cupertino.dart';

import '../model/paramter_api.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;

  MovieLoaded(this.movies);
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}

class MovieSuggestionsLoaded extends MovieState {
  final List<String> suggestions;

  MovieSuggestionsLoaded(this.suggestions);
}
