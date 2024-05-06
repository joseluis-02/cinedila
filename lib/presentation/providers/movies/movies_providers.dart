import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinedila/domain/entities/movie.dart';
import 'package:cinedila/presentation/providers/movies/movies_repository_provider.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovie = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovie);
});

// Casos de uso especificos para realizar cambios o solicitudes
typedef MovieCallBack = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  MovieCallBack fetchMoreMovies;
  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]);

  //Su objetivo es hacer una modificacion al state
  // El state es el lsitado de Movie en este caso
  Future<void> loadNextPage() async {
    currentPage++;

    // Llamar la funcion getNowPlaying
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}
