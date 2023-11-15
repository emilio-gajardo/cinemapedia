import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
// import 'package:flutter/material.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    profilePath: cast.profilePath != null
      ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
      : 'https://t3.ftcdn.net/jpg/03/81/66/86/240_F_381668640_Gv9wytd4ZlIgZWzVGfzSyfaNR7XJiL9p.jpg',
      // : const AssetImage('assets/images/userdefault.jpg'), // * info: imagen local
    character: cast.character,
  );
}