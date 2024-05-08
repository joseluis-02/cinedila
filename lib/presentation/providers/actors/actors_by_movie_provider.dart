import 'package:cinedila/domain/entities/actor.dart';
import 'package:cinedila/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProviuder =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
        (ref) {
  final actorRepository = ref.watch(actorsRepositoryProvider);
  return ActorsByMovieNotifier(getActors: actorRepository.getActorsByMovie);
});
/*
{
  'moviedId': List<Actor>[],
  'moviedId': List<Actor>[],
  'moviedId': List<Actor>[],
  'moviedId': List<Actor>[],
  'moviedId': List<Actor>[],
}
*/
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;
  ActorsByMovieNotifier({required this.getActors}) : super({});
  Future<void> loadActors(String movieId) async {
    //Llamar para traer las peliculas
    if (state[movieId] != null) return;

    //Aqui pedimos las peliculas
    final List<Actor> actors = await getActors(movieId);

    //print('Realizando la peticion http:');
    //Actualizacion del estado
    state = {...state, movieId: actors};
  }
}
