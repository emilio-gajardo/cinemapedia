import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

/// Clase 1
class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const _HomeView();
    return const Scaffold(
      // appBar: AppBar(title: const Text('Movies'),),
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

/// Clase 2
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

/// Clase 3
class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if(initialLoading) return FullScreenLoader();

    final slideShowMovies  = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies    = ref.watch(popularMoviesProvider);
    final upCommingMovies  = ref.watch(upComingMoviesProvider);
    final topRatedMovies   = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            titlePadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          ),
        ),
    
        SliverList(
            delegate: SliverChildBuilderDelegate(
          childCount: 1,
          (context, index) {
            return Column(
              children: [
                // const CustomAppbar(),
                MoviesSlideshow(movies: slideShowMovies),
    
                //* 1 = En cines
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subTitle: '2023',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
    
                //* 2 = Próximamente
                MovieHorizontalListview(
                  movies: upCommingMovies,
                  title: 'Próximamente',
                  subTitle: 'Este mes',
                  loadNextPage: () => ref.read(upComingMoviesProvider.notifier).loadNextPage(),
                ),
    
                //* 3 Populares
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
    
                //* 4 = Mejor calificadas
                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor calificadas',
                  subTitle: 'Desde siempre',
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),
                const SizedBox(height: 25),
              ],
            );
          },
        ))
      ],
    );
  }
}