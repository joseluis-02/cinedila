import 'package:cinedila/domain/entities/movie.dart';
import 'package:cinedila/domain/repositories/local_storage_repository.dart';
import 'package:cinedila/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<StoreMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StoreMoviesNotifier(localStorageRepository: localStorageRepository);
});

/*
{
  232: movie1,
  232: movie2,
  387: movie3,
}
*/
class StoreMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StoreMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<List<Movie>> loadNexPage() async {
    final movies =
        await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;
    final tempMovieMap = <int, Movie>{};
    for (final movie in movies) {
      tempMovieMap[movie.id] = movie;
    }
    state = {...state, ...tempMovieMap};
    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] != null;
    if (isMovieInFavorites) {
      state.remove(movie.id);
      state = {...state};
    } else {
      state = {...state, movie.id: movie};
    }
  }
}
