import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemawik/presentation/providers/providers.dart';
import 'package:cinemawik/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin {
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
    super.build(context);

    final initialLoading = ref.watch(initialLoadingProvider);
    if(initialLoading) return FullScreenLoader();

    /// Remover splash screen hasta que carguen los 4 providers o endpoints
    FlutterNativeSplash.remove();

    final slideShowMovies  = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    //final popularMovies    = ref.watch(popularMoviesProvider);
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
                const SizedBox(height: 10),
                
                //* 1 = En cines
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subTitle: '${DateTime.now().year}',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
                const SizedBox(height: 10),

                //* 2 = Próximamente
                MovieHorizontalListview(
                  movies: upCommingMovies,
                  title: 'Próximamente',
                  // subTitle: 'Este mes',
                  loadNextPage: () => ref.read(upComingMoviesProvider.notifier).loadNextPage(),
                ),

                //* 3 Populares
                // MovieHorizontalListview(
                //   movies: popularMovies,
                //   title: 'Populares',
                //   loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                // ),
    
                //* 4 = Mejor calificadas
                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor calificadas',
                  // subTitle: 'Desde siempre',
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
  @override
  bool get wantKeepAlive => true;
}