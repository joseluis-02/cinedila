import 'package:cinedila/domain/entities/movie.dart';
import 'package:cinedila/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinedila/presentation/providers/providers.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});

  @override
  FavoriteViewState createState() => FavoriteViewState();
}

class FavoriteViewState extends ConsumerState<FavoriteView> {
  bool islastPage = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadNextPage();
    //print('Entra a initial state');
  }

  void loadNextPage() async {
    if (isLoading || islastPage) return;
    isLoading = true;
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNexPage();
    isLoading = false;
    if (movies.isEmpty) {
      islastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final moviesMap = ref.watch(favoriteMoviesProvider);
    List<Movie> movieList = moviesMap.values.toList();

    if (movieList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 60,
              color: colors.primary,
            ),
            Text(
              'Ups!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              'Aún no tienes películas favoritas',
              style: TextStyle(fontSize: 15, color: Colors.black45),
            )
          ],
        ),
      );
    }
    //print(movies);
    return Scaffold(
      body: MovieMonsory(movies: movieList),
    );
  }
}
