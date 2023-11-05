import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.urlBase,
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': Environment.language,
      }
    ),
  );
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('movie/now_playing');
    final MovieDbResponse movieDbResponse = MovieDbResponse.fromJson(response.data);    
    final List<Movie> movies = movieDbResponse
      .results
      .where((moviedb) => moviedb.backdropPath != 'not-found' && moviedb.posterPath != 'not|-found')
      .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
      .toList();
    return movies;
  }

}