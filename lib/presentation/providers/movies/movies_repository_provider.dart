import 'package:cinemawik/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemawik/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. Crea la instancia de MovieRepositoryImpl.
/// 2. Provider inmutable: de solo lectura.
/// 3. Provider: proveedor de información.

final movieRepositoryProvider = Provider((ref) {
    return MovieRepositoryImpl(MoviedbDatasource());
});