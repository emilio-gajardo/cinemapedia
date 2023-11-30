import 'package:cinemawik/domain/datasources/actors_datasource.dart';
import 'package:cinemawik/domain/entities/actor.dart';
import 'package:cinemawik/domain/repositories/actors_repository.dart';


/// Objetivo de clase: hacer de "puente" enter los "gestores de estado" y los "datasource"
class ActorRepositoryImpl extends ActorsRepository {

  final ActorsDatasource datasource;
  ActorRepositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
  
}