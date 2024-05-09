// Cual es el objetivo del mappers?
// como unica mision leer diferentes modelos y crear mi entidad

import 'package:cinedila/domain/entities/movie.dart';
import 'package:cinedila/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinedila/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  //es que nosotros podamos crear
  // Una pelicula basado en algun objeto que podamos recibir
  //  Si viene de IBMdb o The movie db asi susecivamente
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://cdn.pixabay.com/photo/2019/03/21/03/18/film-4070151_1280.jpg',
      releaseDate:
          moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);

  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://cdn.pixabay.com/photo/2019/03/21/03/18/film-4070151_1280.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);
}
