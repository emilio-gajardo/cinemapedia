import 'package:dio/dio.dart';
import 'package:cinemawik/config/constants/environment.dart';
import 'package:cinemawik/domain/entities/actor.dart';
import 'package:cinemawik/domain/datasources/actors_datasource.dart';
import 'package:cinemawik/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemawik/infrastructure/models/moviedb/credits_response.dart';

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
    List<Actor> actors = castResponse
      .cast
      .map((cast) => ActorMapper.castToEntity(cast))
      .toList();
    return actors;
  }

}