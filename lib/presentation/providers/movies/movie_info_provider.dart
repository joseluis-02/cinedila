import 'package:cinedila/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinedila/domain/entities/movie.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final getMovieDetails = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(getMovie: getMovieDetails);
});
/*
{
  '1255212': Movie(),
  '1122552': Movie(),
  '2211265': Movie(),
  '5247852': Movie(),
  '7852420': Movie(),
}
*/
typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;
  MovieMapNotifier({required this.getMovie}) : super({});
  Future<void> loadMovie(String movieId) async {
    //Llamar para traer las peliculas
    if (state[movieId] != null) return;

    //Aqui pedimos las peliculas
    final movie = await getMovie(movieId);

    //print('Realizando la peticion http:');
    //Actualizacion del estado
    state = {...state, movieId: movie};
  }
}
