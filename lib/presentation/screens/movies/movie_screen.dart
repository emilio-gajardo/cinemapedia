import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
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
                      _MovieAttributeStyle(label: 'Fecha de estreno', value: (movie.releaseDate != null) ? (DateFormat('dd MMMM yyyy').format(movie.releaseDate!)): null ),
                      _MovieAttributeStyle(label: 'Generos', value: movie.genreIds.join(', ')),
                      _MovieAttributeStyle(label: 'Popularidad', value: movie.popularity.toString()),

                      // * Calificación
                      SizedBox(
                        child: Row(children: [
                          _MovieAttributeStyle(
                            label: 'Puntuación promedio',
                            // value: movie.voteAverage.toString()
                            value: HumanFormats.number(movie.voteAverage, 1),
                          ),
                          // Icon(Icons.star_outlined, color: Colors.yellow.shade900,),
                        ],),
                      ),
                      
                      _MovieAttributeStyle(label: 'Cantidad de votos', value: movie.voteCount.toString()),
                    ]),
              ),
            
            
            ],
          ),
        ),


        // * Descripción
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
                      const SizedBox(height: 10),
                      Text(movie.overview, style: textStyle.titleSmall),

                      const SizedBox(height: 25),

                      // * Actores
                      Text('Actores', style: textStyle.titleLarge),
                      const SizedBox(height: 10),
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
      actions: [

        // Icono de pelicula favorita
        Stack(
          alignment: Alignment.center,
          children: [
            
            // icono de sombra
            const Icon(Icons.star_border, size: 50, color: Color.fromARGB(60, 158, 158, 158)),
            
            // icono principal
            IconButton(
              onPressed: (){
              // todo: realizar toggle
              },
              icon: const Icon(Icons.star_border, size: 35)
              // icon: Icon(Icons.star, size: 35, color: Colors.yellow.shade800,)
            )
          ],
        )
      ],

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

            // gradiente superior de poster
            const _CustomGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter, 
              stops: [0.85, 1.5], 
              colors: [Colors.transparent, Colors.black54],
            ),

            // gradiente inferior de poster
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.85, 1.5],
              colors: [Colors.transparent, Colors.black54]
            ),


            // gradiente esquina superior derecha
            /* const SizedBox.expand(
               child: DecoratedBox(
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topRight,
                     end: Alignment.bottomLeft,
                     stops: [0.0, 0.15],
                     colors: [Colors.black54, Colors.transparent]
                   )
                 )
               ),
             ),*/

            // gradiente esquina superior izquierda
           /* const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.15],
                    colors: [Colors.black54, Colors.transparent]
                  )
                )
              ),
            ),*/

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
                    // child: Image.network(
                    child: Image(
                      image: _getImageProvider(actor.profilePath),
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

ImageProvider<Object> _getImageProvider(String? profilePath) {
  if (profilePath != null && profilePath.isNotEmpty) {
    // Si profilePath no es nulo ni está vacío, es una imagen de red
    return NetworkImage(profilePath);
  } else {
    // Si profilePath es nulo o está vacío, usa la imagen local
    return const AssetImage('assets/images/userdefault.jpg');
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin,
    required this.end,
    required this.stops,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors,
          )
        )
      ),
    );
  }
}