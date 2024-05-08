import 'package:cinedila/infrastructure/mappers/actor_mapper.dart';
import 'package:cinedila/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';
import 'package:cinedila/config/constants/environment.dart';

import 'package:cinedila/domain/datasources/actors_datasource.dart';
import 'package:cinedila/domain/entities/actor.dart';

class ActorMovieDbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieApiKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    final castResponse = CreditsResponse.fromJson(response.data);
    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();
    return actors;
  }
}
