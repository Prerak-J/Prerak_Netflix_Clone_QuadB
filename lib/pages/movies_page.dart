import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netflix_clone/pages/detail_page.dart';
import 'package:netflix_clone/utils/colors.dart';
import 'package:http/http.dart' as http;

class MoviesPage extends StatefulWidget {
  final PageController homePageController;
  const MoviesPage({super.key, required this.homePageController});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> with AutomaticKeepAliveClientMixin {
  bool _loading = false;

  List<dynamic> movies = [];

  @override
  void initState() {
    fetchMovies();
    super.initState();
  }

  Future<void> fetchMovies() async {
    setState(() {
      _loading = true;
    });
    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/search/shows?q=all'),
    );
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const Dialog(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text('ERROR FETCHING MOVIES'),
                ),
              ),
            ),
          ),
        );
      }
      throw Exception('Failed to load movies');
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _loading
        ? Container(
            alignment: Alignment.center,
            color: primaryBlack,
            child: const CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          )
        : Container(
            padding: const EdgeInsets.all(8.0),
            color: primaryBlack,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  forceMaterialTransparency: true,
                  backgroundColor: secondaryBlack,
                  automaticallyImplyLeading: false,
                  leading: null,
                  leadingWidth: 0.0,
                  floating: true,
                  flexibleSpace: InkWell(
                    onTap: () => widget.homePageController.jumpToPage(1),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.4,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: secondaryBlack,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Search Movies, TV Series...',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                wordSpacing: 0.5,
                                letterSpacing: 0.3,
                                color: Colors.white54),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 40,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: movies[index]);
                  },
                )
              ],
            ),
          );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class MovieCard extends StatefulWidget {
  final dynamic movie;

  const MovieCard({super.key, required this.movie});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  String poster = '', name = '', year = '';
  List<String> genre = [''];
  @override
  void initState() {
    poster = (widget.movie['show']['image'] != null) ? widget.movie['show']['image']['medium'] : '';
    name = widget.movie['show']['name'] ?? '';
    year = widget.movie['show']['premiered'] ?? 'Year ';
    if (widget.movie['show']['genres'] != null) {
      genre = List<String>.from(widget.movie['show']['genres']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(movie: widget.movie),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: (poster != '')
                      ? NetworkImage(poster)
                      : const AssetImage('assets/default_movie.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${year.substring(0, 4)} • ${genre[0]}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
