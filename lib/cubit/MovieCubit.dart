import 'package:bloc/bloc.dart';
import 'package:try_screen_search/cubit/MovieState.dart';

import '../model/services.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial());

  void searchMovies(String query) async {
    emit(MovieLoading());
    try {
      final movies = await ApiService.fetchMovies(query);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError('Failed to fetch movies.'));
    }
  }

  void updateSuggestions(String query) async {
    try {
      final suggestions = await ApiService.fetchMovieSuggestions(query);
      emit(MovieSuggestionsLoaded(suggestions));
    } catch (e) {
      emit(MovieError('Failed to fetch suggestions.'));
    }
  }
}
