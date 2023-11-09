import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
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