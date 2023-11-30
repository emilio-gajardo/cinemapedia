import 'package:cinemawik/domain/entities/movie.dart';

abstract class LocalStorageDatasource {

  /// - Recibe la película completa
  Future<void> toggleFavorite(Movie movie);
  
  /// - Valida si la película es favorita en base a su id
  Future<bool> isMovieFavorite(int movieId);
  
  /// - Carga lista de las peliculas favoritas
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0});
}