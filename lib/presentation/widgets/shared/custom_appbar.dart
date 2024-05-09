import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinedila/domain/entities/movie.dart';
import 'package:cinedila/presentation/providers/providers.dart';
import 'package:cinedila/presentation/delegates/search_movie_delegate.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.labelLarge;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                Icons.movie_filter_outlined,
                color: colors.primary,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Cinemadelia',
                style: titleStyle,
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    // TODO:
                    //llamamos nuestro provider :searchedMoviesProvider
                    final searchedMovies = ref.read(searchedMoviesProvider);
                    //Recuperamos el valor de query de nuestro provider
                    final searchQuery = ref.read(searchQueryProvider);

                    showSearch<Movie?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchMovieDelegate(
                        initialsMovies: searchedMovies,
                        searchMovies: ref
                            .read(searchedMoviesProvider.notifier)
                            .searchMoviesByQuery,
                      ),
                    ).then(
                      (movie) {
                        if (movie == null) return;
                        context.push('/home/0/movie/${movie.id}');
                      },
                    );
                    //print(movie?.title);
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
      ),
    );
  }
}
