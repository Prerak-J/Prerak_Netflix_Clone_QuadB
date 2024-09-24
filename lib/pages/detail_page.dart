import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:netflix_clone/utils/colors.dart';

class DetailPage extends StatefulWidget {
  final dynamic movie;
  const DetailPage({super.key, this.movie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String poster = '';
  String name = '';
  String year = '';
  String runtime = '';
  String lang = '';
  String description = '';
  String rating = '-';
  List<String> genre = [''];

  Widget posterImage = Container();
  @override
  void initState() {
    poster = (widget.movie['show']['image'] != null) ? widget.movie['show']['image']['original'] : '';
    name = widget.movie['show']['name'] ?? '';
    year = widget.movie['show']['premiered'] ?? 'Year ';
    if (widget.movie['show']['genres'] != null) {
      genre = List<String>.from(widget.movie['show']['genres']);
    }
    runtime = (widget.movie['show']['runtime'] != null) ? '${widget.movie['show']['runtime']} min' : '';
    lang = (widget.movie['show']['language'] != null) ? '${widget.movie['show']['language']}' : '';

    //RATING
    {
      num ratingNum = (widget.movie['show']['rating'] != null) ? widget.movie['show']['rating']['average'] ?? 0.0 : 0.0;
      rating = ratingNum.toStringAsFixed(1);
    }

    //SUMMARY
    {
      description = widget.movie['show']['summary'] ?? '';
      final doc = parse(description);
      description = parse(doc.body!.text).documentElement!.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //POSTER
    posterImage = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 20),
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: (poster != '') ? NetworkImage(poster) : const AssetImage('assets/default_movie.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: scaffoldBlack,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: scaffoldBlack,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    poster != ''
                        ? Image.network(
                            poster,
                            fit: BoxFit.fill,
                            height: 400,
                            width: double.infinity,
                          )
                        : Image.asset(
                            'assets/default_movie.png',
                            fit: BoxFit.fill,
                            height: 400,
                            width: double.infinity,
                          ),
                    posterImage,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        softWrap: true,
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          rating == '0.0' ? '-' : rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(
                            Icons.star_rate,
                            color: Colors.amberAccent,
                            size: 22,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  '${year.substring(0, 4)} | ${genre.join(', ')} | $runtime',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                child: Text(
                  'Language: $lang',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
