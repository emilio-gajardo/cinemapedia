import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {

  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(
    this.datasource
  );


  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    final res = datasource.loadMovies(limit: limit, offset: offset);
    // print('>> datasource.loadMovies: $res');
    return res;
  }

  @override
  Future<void> toggleFavorites(Movie movie) {
    return datasource.toggleFavorites(movie);
  }

}