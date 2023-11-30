import 'package:cinemawik/domain/entities/entities.dart';
import 'package:cinemawik/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemawik/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends ConsumerWidget {
  final int currentIndex;
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex
  });

  void onItemTapped(BuildContext context, int index, WidgetRef ref) {
    switch(index) {
      case 0: context.go('/home/0'); break;
      case 1: context.go('/home/1'); break;
      case 2: context.go('/home/2'); break;
      case 3: irABuscarPelicula(context, ref); break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      // showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onItemTapped(context, index, ref),
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.secondary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Populares'),
        BottomNavigationBarItem(icon: Icon(Icons.star),label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
      ]
    );
  }

  void irABuscarPelicula(BuildContext context, WidgetRef ref) {
      final searchedMovies = ref.read(searchedMoviesProvider);
      final searchQuery = ref.read(searchQueryProvider);
      // * buscar
      showSearch<Movie?>(
        query: searchQuery,
        context: context,
        delegate: SearchMovieDelegate(
          initialMovies: searchedMovies,
          searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery
        )
      ).then((movie) {
        if(movie == null) return;
        context.push('/home/0/movie/${movie.id}');
      });
  }
}