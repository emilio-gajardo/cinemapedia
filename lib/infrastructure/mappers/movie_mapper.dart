import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

/// El objetivo es crear un 'objeto pelicula' en base a algun objeto recibido

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
    genreIds: moviedb.genreIds.map((numero) => numero.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${moviedb.posterPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',

     releaseDate: (moviedb.releaseDate != null && moviedb.releaseDate.toString().isNotEmpty)
      ? DateTime.tryParse(moviedb.releaseDate.toString())
      : null,

    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );

/// * Retorna los detalles de una sola pelicula
  static Movie movieDetailsToEntity(MovieDetails movie) => Movie(
    adult: movie.adult,
    backdropPath: (movie.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${movie.backdropPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
    genreIds: movie.genres.map((genre) => genre.name).toList(),
    id: movie.id,
    originalLanguage: movie.originalLanguage,
    originalTitle: movie.originalTitle,
    overview: movie.overview,
    popularity: movie.popularity,
    posterPath: (movie.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${movie.posterPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
    
    releaseDate: (movie.releaseDate != null && movie.releaseDate.toString().isNotEmpty)
      ? DateTime.tryParse(movie.releaseDate.toString())
      : null,


    title: movie.title,
    video: movie.video,
    voteAverage: movie.voteAverage,
    voteCount: movie.voteCount,
  );

}
