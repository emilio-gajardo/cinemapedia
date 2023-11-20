import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesRepository {

  /// 1. En cines GET >> movie/now_playing 
  Future<List<Movie>> getNowPlaying({int page = 1});

  /// 2. Próximamente GET >> movie/upcoming
  Future<List<Movie>> getUpcoming({int page = 1});
  
  /// 3. Populares GET >> movie/popular
  Future<List<Movie>> getPopular({int page = 1});

  /// 4. Mejor calificadas GET >> movie/top_rated
  Future<List<Movie>> getTopRated({int page = 1});

  /// 5. Detalle pelicula GET movie/movieId
  Future<Movie> getMovieById(String id);

  /// 6. Busca peliclas por su nombre
  Future<List<Movie>> searchMovies(String query);
}
