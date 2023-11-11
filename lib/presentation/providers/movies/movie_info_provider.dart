import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(getMovie: movieRepository);
});

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;
  MovieMapNotifier({required this.getMovie,}):super({});

  Future<void> loadMovie(String movieId) async {
    if(state[movieId] != null) return; // ya esta cargada la pelicula
    print('>> Realizando petición HTPP');
    final movie = await getMovie(movieId);
    state = { ...state, movieId: movie };

  }
}