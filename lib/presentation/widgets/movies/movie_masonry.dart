import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cinemawik/domain/entities/movie.dart';
import 'package:cinemawik/presentation/widgets/movies/movie_poster_link.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage; // el infinite scroll se creara recibiendo el VoidCallback

  const MovieMasonry({
    super.key, 
    required this.movies,
    this.loadNextPage
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {

  final ScrollController  scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(widget.loadNextPage == null) return;

      if((scrollController.position.pixels + 10) >= scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 10), // separacion bordes externos
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 12), // separacion bordes externos
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3, // son las columnas
        mainAxisSpacing: 15, // separacion entre filas
        crossAxisSpacing: 15, // separacion entre columnas
        itemCount: widget.movies.length,
        // scrollDirection: Axis.vertical,
        // physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if(index == 1) {
            return Column(
              children: [
                const SizedBox(height: 23.5),// espacio superior de columna del medio
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}