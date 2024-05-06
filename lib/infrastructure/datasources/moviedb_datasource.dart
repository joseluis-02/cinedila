// Especializado en movie db
import 'package:cinedila/infrastructure/mappers/movie_mapper.dart';
import 'package:dio/dio.dart';
import 'package:cinedila/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinedila/config/constants/environment.dart';
import 'package:cinedila/domain/datasources/movies_datasource.dart';
import 'package:cinedila/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieApiKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    //Esta es la foirma de pasar los datos obtenenidos de un Api
    // En este caso The movie db
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }
}
