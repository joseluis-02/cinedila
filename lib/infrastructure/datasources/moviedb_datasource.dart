// Especializado en movie db
import 'package:dio/dio.dart';
import 'package:cinedila/infrastructure/mappers/movie_mapper.dart';

import 'package:cinedila/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinedila/config/constants/environment.dart';
import 'package:cinedila/domain/datasources/movies_datasource.dart';
import 'package:cinedila/domain/entities/movie.dart';

List<Movie> _getMoviesJson(Map<String, dynamic> json) {
  final movieDBResponse = MovieDbResponse.fromJson(json);
  //Esta es la foirma de pasar los datos obtenenidos de un Api
  // En este caso The movie db
  final List<Movie> movies = movieDBResponse.results
      .where(
          (moviedb) => moviedb.posterPath != '' || moviedb.backdropPath != '')
      .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
      .toList();
  movies.removeWhere((movie) => !movie.posterPath.contains('.jpg'));
  return movies;
}

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieApiKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });

    return _getMoviesJson(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {
      'page': page,
    });

    return _getMoviesJson(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    // TODO: implement getTopRated
    final response = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
    });
    return _getMoviesJson(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    // TODO: implement getUpcoming
    final response = await dio.get('/movie/upcoming', queryParameters: {
      'page': page,
    });
    return _getMoviesJson(response.data);
  }
}
