import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_color.dart';
import 'cubit/MovieCubit.dart';
import 'cubit/MovieState.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (_) => MovieCubit(),
        child: BlocBuilder<MovieCubit, MovieState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  // Search Text Field
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      labelText: 'Search',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            context
                                .read<MovieCubit>()
                                .searchMovies(_searchController.text);
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    onChanged: (value) {
                      context.read<MovieCubit>().updateSuggestions(value);
                    },
                    onFieldSubmitted: (query) {
                      if (query.isNotEmpty) {
                        context.read<MovieCubit>().searchMovies(query);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Suggestion List
                  if (state is MovieSuggestionsLoaded &&
                      _searchController.text.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = state.suggestions[index];
                          return ListTile(
                            title: Text(
                              suggestion,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              _searchController.text = suggestion;
                              context
                                  .read<MovieCubit>()
                                  .searchMovies(suggestion);
                              setState(() {
                                context
                                    .read<MovieCubit>()
                                    .updateSuggestions('');
                              });
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Movie List or Loading Indicator
                  if (state is MovieLoading)
                    const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),

                  if (state is MovieLoaded)
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.movies.length,
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: AppColor.blackColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 2.0),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: movie.posterPath.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              movie.posterPath,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.movie,
                                            size: 50, color: Colors.white),
                                  ),
                                  const SizedBox(width: 20),

                                  // Movie details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${movie.releaseDate.split('-')[0]}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          ' ${movie.mainCharacters.join(', ')}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(color: Colors.grey);
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
