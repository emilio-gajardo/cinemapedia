import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(movieInfoProvider); // mapa
    final Movie? movie = movies[widget.movieId]; // elemento opcional
    

    if (movie == null) {
      // si la pelicula no esta cargada muestra un elemento de carga
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1,
          ))
        ],
      ),
    );
  }
}

/// [Clase que configura la descripción] de una pelicula
class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // * Imagen
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      movie.posterPath,
                      width: size.width * 0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              // * Atributos
              SizedBox(
                width: (size.width - 60) * 0.7,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _MovieAttributeStyle(label: 'Título original', value: movie.originalTitle),
                      _MovieAttributeStyle(label: 'Título es-mx', value: movie.title),
                      _MovieAttributeStyle(label: 'Fecha de estreno', value: DateFormat('dd MMMM yyyy').format(movie.releaseDate)),
                      _MovieAttributeStyle(label: 'Generos', value: movie.genreIds.join(', ')),
                      _MovieAttributeStyle(label: 'Popularidad', value: movie.popularity.toString()),

                      // * Calificación
                      SizedBox(
                        child: Row(children: [
                          _MovieAttributeStyle(label: 'Puntuación promedio', value: movie.voteAverage.toString()),
                          // Icon(Icons.star_outlined, color: Colors.yellow.shade900,),
                        ],),
                      ),
                      
                      _MovieAttributeStyle(label: 'Cantidad de votos', value: movie.voteCount.toString()),
                    ]),
              ),
            
            
            ],
          ),
        ),

        SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Descripción', style: textStyle.titleLarge),
                      const SizedBox(height: 10,),
                      Text(movie.overview, style: textStyle.titleSmall),

                      _ActorsByMovie(movieId: movie.id.toString()),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

/// [Clase que configura la imagen o poster] de una pelicula
class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.6,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // title: Text(movie.title, style: const TextStyle(fontSize: 20)),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1.0],
                          colors: [Colors.transparent, Colors.black87]))),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          // end: Alignment.bottomCenter,
                          stops: [0.0, 0.25],
                          colors: [Colors.black87, Colors.transparent]))),
            ),

          ]
        ),
      ),
    );
  }
}


/// [Clase que configura los estilos visuales] de los atributos de una pelicula
class _MovieAttributeStyle extends StatelessWidget {
  final String? label;
  final String? value;

  const _MovieAttributeStyle({this.label, this.value});

  @override
  Widget build(BuildContext context) {
  final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0), // Espacio de 5px arriba
        RichText(
          text: TextSpan(
            style: textStyle.bodyMedium,
            children: [
              const TextSpan(text: '• ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: value, style: TextStyle(color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
        const SizedBox(height: 5), // Espacio de 10px abajo
      ],
    );
  }
}

///  [Clase que muestra los actores]
class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if(actorsByMovie[movieId] == null) return const CircularProgressIndicator(strokeWidth: 2);
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Actor foto
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 5),

                // Actor nombre
                Text(actor.name, maxLines: 2),
                Text(actor.character ?? '', maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                ),


              ],
            ),
          );
        },
      ),
    );
  }
}