import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_providers.dart';

/// - Clase que cambia en base a otros providers

final initialLoadingProvider = Provider<bool>((ref) {

  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(popularMoviesProvider).isEmpty;
  final step3 = ref.watch(upComingMoviesProvider).isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).isEmpty;

  if (step1 || step2 || step3 || step4) return true;

  return false; /// finaliza la carga de todos los endpoints llamados
});