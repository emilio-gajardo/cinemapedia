import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cinemawik/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {

  final Movie movie;

  const MoviePosterLink({
    super.key,
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return FadeIn(
      delay: Duration(milliseconds: random.nextInt(450) + 0 ),
      child: GestureDetector(
        onTap: () => context.push('/home/0/movie/${movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: Image.network(
            movie.posterPath,
            fit: BoxFit.cover,
            height: 180,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return FadeIn(child: child);
            },
          ),
        ),
      ),
    );
  }
}