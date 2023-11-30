import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemawik/domain/entities/movie.dart';
import 'package:cinemawik/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String> ((ref) => '');

/// - Notifier: SearchedMoviesNotifier
/// - List: ``List<Movie>``
final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);
  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies,
    ref: ref,
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier <List<Movie>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;
  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }):super([]);
  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}