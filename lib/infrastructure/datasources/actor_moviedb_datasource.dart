import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMovieDbDatasource extends ActorsDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.urlBase,
      queryParameters: {
        'api_key': Environment.theMovieDBKey,
        'language': Environment.language
      }
    ),
  );

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('movie/$movieId/credits');
    final CreditsResponse castResponse = CreditsResponse.fromJson(response.data);
    final List<Actor> actors = castResponse
      .cast
      .map((cast) => ActorMapper.castToEntity(cast))
      // .where((actor) => actor.profilePath != 'not-found' && actor.profilePath != 'notfound')
      .toList();
    return actors;
  }

}