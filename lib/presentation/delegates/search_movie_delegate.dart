import 'dart:async';

import 'package:cinemawik/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

import 'package:cinemawik/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController<bool>.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }):super(
    searchFieldLabel: 'Buscar películas',
  );

  void clearStreams() {
    debouncedMovies.close();
  }


  void _onQueryChanged(String query) {

    isLoadingStream.add(true); // girar icono

    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () async {
        // * buscar pelicula y emitir al stream
        // if(query.isEmpty){
        //   debouncedMovies.add([]);
        //   return;
        // }

        final movies = await searchMovies(query);
        initialMovies = movies;
        debouncedMovies.add(movies);
        isLoadingStream.add(false);

      }
    );
  }

  // @override
  // String get searchFieldLabel => 'Buscar película';

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieSearchItem(
              movie: movies[index],
              onMovieSelected: (context, movie){
                clearStreams();
                close(context, movie);
              },
            );
          }
        );
      }
    );
  }


  /// buildActions() Construye acciones
  @override
  List<Widget>? buildActions(BuildContext context) {

    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if(snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.highlight_off)
            ),
          );
        },
      ),
    



      
    ];
  }

  /// buildLeading() Construye iconos
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back)
    );
  }

  /// buildLeading() Entrega los resultados que se muestran después que el usuario hace enter
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  /// buildSuggestions() Es cuando el usuario esta escribiendo la busqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}


/// Clase que lista los resultados de las peliculas encontradas segun el termino de busqueda
class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function(BuildContext context, Movie movie) onMovieSelected;
  const _MovieSearchItem({
    required this.movie,
    required this.onMovieSelected
  });

  bool _hasValidPoster() {
     // ignore: unnecessary_null_comparison
    return (movie.posterPath != null && movie.posterPath.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
  
    // final textStyles = Theme.of(context).textTheme;

    if (!_hasValidPoster()) {
      return const SizedBox.shrink();
    }

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
      
              // * Image
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      movie.posterPath,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2))
                          );
                        }
                        return FadeIn(child: child);
                      },
                    ),

                  ),
              ),

              const SizedBox(width: 10),
          
              // * Titulo y fecha de estreno
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
      
                    Text('Título: ${movie.title}'),
      
                    // * Fecha de estreno
                    (movie.releaseDate != null && movie.releaseDate is DateTime)
                      ? Text('Estreno: ${DateFormat('MMMM yyyy').format( movie.releaseDate! )}')
                      : const Text('Estreno: no disponible', style: TextStyle(color: Colors.grey)),
      
                      // * Votos
                      Row(
                        children: [
                          const Text('Valoración: '),
                          Icon(Icons.star_half, color: Colors.yellow.shade900),
                          const SizedBox(width: 10),
                          Text(
                            HumanFormats.number(movie.voteAverage, 1),
                            style: TextStyle(color: Colors.yellow.shade900)
                          ),
                        ],
                      ),
      
                    // * Descripción
                    // ignore: unnecessary_null_comparison
                    (movie.overview != null && movie.overview.length > 90 )
                      ? Text('${movie.overview.substring(0, 90)}...')
                      : Text(movie.overview),
                       
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}