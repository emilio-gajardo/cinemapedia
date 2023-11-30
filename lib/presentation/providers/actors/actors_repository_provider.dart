import 'package:cinemawik/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemawik/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Información de la clase:
/// 1. Crea la instancia de MovieRepositoryImpl.
/// 2. Provider inmutable: de solo lectura.
/// 3. Provider: proveedor de información.

final actorsRepositoryProvider = Provider((ref) {
    return ActorRepositoryImpl(ActorMovieDbDatasource());
});