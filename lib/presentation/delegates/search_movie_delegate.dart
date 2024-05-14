import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinedila/domain/entities/movie.dart';
import 'package:flutter/material.dart';

// DEfinimos un tipo de funcion especifica
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  //Creamos un variable de nuestro tipo de funcion SearchMoviesCallback
  final SearchMoviesCallback searchMovies;
  //Para optimizar la tarea de busqueda
  //List<Movie> es para especificar que tipo de dato fluye
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isWriting = StreamController.broadcast();
  Timer? _debounceTimer;

  //Lista inicial de peliculas
  List<Movie> initialsMovies;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialsMovies})
      : super(
            searchFieldLabel: 'Título de la película',
            textInputAction: TextInputAction.search);
  //Funcion para limpiar las emisiones de Strams
  void clearStrems() {
    debouncedMovies.close();
  }

  //Funcion que emite valor
  void _onQueryChanged(String query) {
    //Empiezo a escribir emito la señal para colocar escribiendo
    isWriting.add(true);
    //Esto sirve para ya no seguir y cancelar la emision
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    //Esto sirve para esperar el tiempo para disparar la peticion
    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      //Cuando deja de escribir durante 500 milisegundos
      //print('Buscando peliculas');
      //Aqui es donde hacemos la petion a nuestro endpoint
      /*if (query.isEmpty) {
        debouncedMovies.add([]);
        return;
      }¨*/
      final movies = await searchMovies(query);
      initialsMovies = movies;
      debouncedMovies.add(movies);
      //Despues de cargar las peliculas dejo de mostrar escribiendo
      isWriting.add(false);
    });
  }

//Un solo metodo para llamar la lista de peliculas
  Widget buildResultAndSuggestions() {
    return StreamBuilder(
      initialData: initialsMovies,
      //future: searchMovies(query),
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItem(
                  movie: movies[index],
                  onMovieSelected: (context, movie) {
                    clearStrems();
                    close(context, movie);
                  },
                ));
      },
    );
  }

  // Para cambiar el placeholder del search delegate
  //@override
  //String get searchFieldLabel => 'Título de la película';
  @override
  List<Widget>? buildActions(BuildContext context) {
    // Retorna una lista de widgets
    //return [const Text('Hola mundo')];
    //print('El valor de query es: $query');
    return [
      StreamBuilder(
        initialData: false,
        stream: isWriting.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              infinite: true,
              child: const IconButton(
                  onPressed: null, icon: Icon(Icons.refresh_rounded)),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear_rounded),
            ),
          );
        },
      ),
      //if (query.isNotEmpty)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Esto puede o no regresar un widget
    //return const Text('buildLeading');
    return IconButton(
      onPressed: () {
        clearStrems();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Aqui se tiene que si o si regresar un resulatdo
    return buildResultAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //llamamos la funcion_onQueryChanged
    _onQueryChanged(query);
    // Esto tambien es un metodo que debe regresar algo
    //return const Text('buildSuggestions');
    return buildResultAndSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //Imagen de la pelicula
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.2,
              child: FadeIn(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    fit: BoxFit.cover,
                    movie.posterPath,
                  ),
                ),
              ),
            ),
            // Agregamos espacio horizontal entre la imagen con la descripcion
            const SizedBox(
              width: 10,
            ),
            //Descripcion de la pelicula
            SizedBox(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyle.titleMedium,
                    maxLines: 2,
                  ),
                  (movie.overview.length > 180)
                      ? Text(
                          '${movie.overview.substring(0, 180)}...',
                          style: textStyle.titleSmall,
                        )
                      : Text(
                          movie.overview,
                          style: textStyle.titleSmall,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
