import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDBKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';
  static String language = dotenv.env['LANGUAGE'] ?? 'No hay idioma definido';
  static String urlBase = dotenv.env['URL_BASE'] ?? 'URL base no definido';
}