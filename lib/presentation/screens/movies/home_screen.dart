import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

/// Clase 1
class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int pageIndex;
  const HomeScreen({
    super.key,
    required this.pageIndex
  });

  final viewRoutes = const <Widget> [
    HomeView(),
    CategoriesView(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    // return const _HomeView();
    return Scaffold(
      // appBar: AppBar(title: const Text('Movies'),),
      // body: HomeView(),
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}
