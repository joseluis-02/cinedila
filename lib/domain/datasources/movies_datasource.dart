import 'package:cinedila/domain/entities/movie.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  //Obtener peliculas de top rated = (Los mas valorados)
  Future<List<Movie>> getTopRated({int page = 1});
  // Funcion abstracta para obtener peliculas Upcoming= Proximo (peliculas proximamente)
  Future<List<Movie>> getUpcoming({int page = 1});
  //Obtener la pelicula por Id
  Future<Movie> getMovieById(String id);

  //Buscar paginas
  Future<List<Movie>> searchMovie(String query);
}
