// Especializado en movie db
import 'package:dio/dio.dart';
import 'package:cinedila/domain/entities/video.dart';
import 'package:cinedila/infrastructure/mappers/video_mapper.dart';
import 'package:cinedila/infrastructure/models/moviedb/moviedb_videos.dart';

import 'package:cinedila/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinedila/infrastructure/mappers/movie_mapper.dart';

import 'package:cinedila/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinedila/config/constants/environment.dart';
import 'package:cinedila/domain/datasources/movies_datasource.dart';
import 'package:cinedila/domain/entities/movie.dart';

/*List<Movie> _getMoviesJson(Map<String, dynamic> json) {
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
*/

class MoviedbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {
      'Authorization': 'Bearer ${Environment.theMovieApiKey}',
      'Content-Type': 'application/json',
    },
    queryParameters: {
      'language': 'es-MX',
    },
  ));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();
    movies.removeWhere((movie) => !movie.posterPath.contains('.jpg'));
    movies.removeWhere((movie) => !movie.backdropPath.contains('.jpg'));
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {
      'page': page,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {
      'page': page,
    });
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      return throw Exception('Película con el id: $id no existe');
    }
    final movieDetails = MovieDetails.fromJson(response.data);
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    if (query.isEmpty) return [];
    final response = await dio.get('/search/movie', queryParameters: {
      'query': query,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if (moviedbVideo.site == 'YouTube') {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }
}
