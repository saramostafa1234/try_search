import 'package:flutter/material.dart';
import 'package:try_screen_search/app_color.dart';
import 'model/paramter_api.dart';
import 'model/services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> _movies = [];
  List<String> _suggestions = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
                      _searchMovies(_searchController.text);
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
                _updateSuggestions(value);
              },
              onFieldSubmitted: (query) {
                if (query.isNotEmpty) {
                  _searchMovies(query);
                }
              },
            ),
            const SizedBox(height: 20),

            // Suggestion List
            // if (_suggestions.isNotEmpty && _searchController.text.isNotEmpty)
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: _suggestions.length,
            //       itemBuilder: (context, index) {
            //         final suggestion = _suggestions[index];
            //         return ListTile(
            //           title: Text(
            //             suggestion,
            //             style: const TextStyle(color: Colors.white),
            //           ),
            //           onTap: () {
            //             _searchController.text = suggestion;
            //             _searchMovies(suggestion);
            //             setState(() {
            //               _suggestions.clear(); // تختفي قائمة الاقتراحات
            //             });
            //           },
            //         );
            //       },
            //     ),
            //   ),
            const SizedBox(height: 20),

            // Movie List
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : _movies.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        'assets/images/Icon material-local-movies (1).png'),
                    const SizedBox(height: 10),
                    const Text('No movies found',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              )
                  : ListView.separated(
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return GestureDetector(
                    onTap: () { print("sara");
                    },
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
                              borderRadius:
                              BorderRadius.circular(8.0),
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
                itemCount: _movies.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search and suggestions functions (organized outside of build)
  void _searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await ApiService.fetchMovies(query);
      setState(() {
        _movies = results;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateSuggestions(String query) async {
    final suggestions = await ApiService.fetchMovieSuggestions(query);
    setState(() {
      _suggestions = suggestions;
    });
  }
}
