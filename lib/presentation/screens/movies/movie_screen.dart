import 'package:cinemawik/config/helpers/human_formats.dart';
import 'package:cinemawik/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';



import 'package:cinemawik/domain/entities/movie.dart';
import 'package:cinemawik/presentation/providers/providers.dart';


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
      return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1
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
    final themePrimaryColor = Theme.of(context).primaryColor;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // * Imagen
              // Column(
              //   children: [
              //     ClipRRect(
              //       borderRadius: BorderRadius.circular(20),
              //       child: Image.network(
              //         movie.posterPath,
              //         width: size.width * 0.3,
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(width: 20),

              // * Atributos
              SizedBox(
                // width: (size.width - 60) * 0.7,
                width: (size.width - 60),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                
                        // _MovieAttributeStyle(label: 'Título original', value: movie.originalTitle),
                        // _MovieAttributeStyle(label: 'Título es-mx', value: movie.title),
                        movieTitleStyle(movie, textStyle),
                        _MovieAttributeStyle(label: 'Estreno', value: (movie.releaseDate != null) ? (DateFormat('dd MMMM yyyy').format(movie.releaseDate!)): null ),
                        _MovieAttributeStyle(label: 'Generos', value: movie.genreIds.join(', ')),
                        // _MovieAttributeStyle(label: 'Popularidad', value: movie.popularity.toString()),
                
                        // * Puntuación
                        moviePuntuacionStyle(movie, textStyle, themePrimaryColor),
                
                        _MovieAttributeStyle(label: 'Votos', value: movie.voteCount.toString()),
                      ]
                  ),
                ),
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

                      //* Descripción
                      _DescripcionMovie(overview: movie.overview),

                      // * Actores
                      _ActorsByMovie(movieId: movie.id.toString()),

                      //* Videos de la película (si tiene)
                      VideosFromMovie( movieId: movie.id ),

                      //* Películas similares = Recomendaciones
                      SimilarMovies(movieId: movie.id ),

                      const SizedBox(height: 10),
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

  ///* Meotod que muestra el título de la película
  Widget movieTitleStyle(Movie movie, textStyle) {
    // ignore: unnecessary_null_comparison
    if(movie.title == null || movie.title.isEmpty) return const SizedBox.shrink();

    final title = Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      // padding: const EdgeInsets.all(8),
      child: RichText(
        text: TextSpan(
          style: textStyle.titleLarge,
          children: [
            TextSpan(
              text: movie.title,
              style: const TextStyle(fontWeight: FontWeight.bold)
            )
          ]
        )
      ),
    );
    return title;
  }

    ///* Metodo que muesta la puntuacion de la película
  Widget moviePuntuacionStyle(movie, textStyle, themePrimariColor) {
    final double voteAverage = (movie.voteAverage == null || movie.voteAverage == 0)
      ? 0.0
      : movie.voteAverage;

    final puntuacion = SizedBox(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
                text: TextSpan(
                  style: textStyle.bodyMedium,
                  children: [
                    const TextSpan(
                      text: 'Puntuación: ',
                      // style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: HumanFormats.number(voteAverage, 1),
                      style: TextStyle(color: themePrimariColor)
                    ),
                    TextSpan(
                      text: ' / 10',
                      style: TextStyle(color: themePrimariColor)
                    ),
                  ],
                ),
            ),
          ),
        ]
      ),
    );

    return puntuacion;
  }

}


/// - Emite un bool = ref
/// - Pide un int = movieID
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

///* [Clase que configura la imagen o poster] de una pelicula
class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final AsyncValue<bool> isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
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
            // const Icon(Icons.star_border, size: 50, color: Color.fromARGB(60, 158, 158, 158)),
            
            // icono principal
            IconButton(
              onPressed: () async {
                // ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
                await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);
                ref.invalidate(isFavoriteProvider(movie.id)); // se invalida para reacer la peticion
              },
              icon: isFavoriteFuture.when(
                loading: () => const CircularProgressIndicator(strokeWidth: 2),
                data: (isFavorite) => isFavorite
                  ? Icon(Icons.star, size: 35, color: Colors.yellow.shade800)
                  : const Icon(Icons.star_border, size: 35),
                error: (_, __) => throw UnimplementedError(), 
              ),
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


///* [Clase que configura los estilos visuales] de los atributos de una pelicula
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
        // const SizedBox(height: 5.0), // Espacio de 5px arriba
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              style: textStyle.bodyMedium,
              children: [
                // const TextSpan(text: '• ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '$label: ', /*style: const TextStyle(fontWeight: FontWeight.bold)*/),
                TextSpan(text: value, style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
        ),
        // const SizedBox(height: 5), // Espacio de 10px abajo
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
    final textStyle = Theme.of(context).textTheme;
    final actorsByMovie = ref.watch(actorsByMovieProvider);
    if(actorsByMovie[movieId] == null) return const CircularProgressIndicator(strokeWidth: 2);
    final actors = actorsByMovie[movieId]!;

    if(actors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actores', style: textStyle.titleLarge),
        SizedBox(
          height: 280,
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

                    // const SizedBox(width: 5),

                    // Actor nombre
                    Text(actor.name, maxLines: 1),
                    Text(actor.character ?? '', maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),


                  ],
                ),
              );
            },
          ),
        ),
      ],
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
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.stops,
    required this.colors
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
            colors: colors
          )
        )
      ),
    );
  }
}

/// Clase que crea y muestra el campo de Descripcion de pelicula
class _DescripcionMovie extends StatelessWidget {
  final String overview;
  const _DescripcionMovie({required this.overview});
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    // ignore: unnecessary_null_comparison
    if (overview == null || overview.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sinopsis', style: textStyle.titleLarge),
        const SizedBox(height: 10),
        Text(overview, style: textStyle.titleSmall),
        const SizedBox(height: 25)
      ],
    );
  }
}