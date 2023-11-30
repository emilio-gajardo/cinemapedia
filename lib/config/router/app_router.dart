import 'package:go_router/go_router.dart';
import 'package:cinemawik/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
          
          int pageIndex = int.parse(state.pathParameters['page'] ?? '0');

          /// Evalua la cantidad de paginas validas en la app, (home= 0, categorias=1, favoritos=2)
          if(pageIndex > 2 || pageIndex < 0) pageIndex = 0;
          
          return HomeScreen(pageIndex: pageIndex);
        },
        routes: [
          GoRoute(
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (context, state) {
                final movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen(movieId: movieId);
              }),
        ]
    ),

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    ),


  ],
);
