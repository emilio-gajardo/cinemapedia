import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex
  });

  void onItemTapped(BuildContext context, int index) {
    switch(index) {
      case 0: context.go('/home/0'); break;
      case 1: context.go('/home/1'); break;
      case 2: context.go('/home/2'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) => onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label),
          label: 'Categorías'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Favoritos'
        ),
      ]
    );
  }
}