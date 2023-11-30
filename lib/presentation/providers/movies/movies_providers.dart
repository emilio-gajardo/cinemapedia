import 'package:cinemawik/domain/entities/movie.dart';
import 'package:cinemawik/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. Clase que permite la reutilización de casos de usos
/// 2. nowPlaying: es un servicio que retorna las peliculas que ahora estan en el cine
/// 3. StateNotifierProvider: Es un proveedor de información que notifica cuando cambia su estado
/// 4. MoviesNotifier: Clase que lo controla
/// 5. `List<Movie>`: La data o state

/// * GET >> movie/now_playing
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// * GET >> movie/popular
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// * GET >> movie/upcoming
final upComingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// * GET >> movie/top_rated
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// typedef MovieCallback: es un alias de una función
typedef MovieCallback = Future<List<Movie>> Function({int page});

/// 1. StateNotifier: pide el tipo de estado que va a mantener
/// 2. MoviesNotifier: Solo necesita saber cual es el caso de uso para traer las películas
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies,
  }): super([]);

  /// El objetivo es hacer alguna modificación al `state o sea al List<Movie>`
  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies]; // regresa un nuevo estado

    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}