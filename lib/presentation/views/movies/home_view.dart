import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinedila/presentation/providers/providers.dart';
import 'package:cinedila/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadHomeScreenProvider);
    if (initialLoading) return const FullScreenLoader();
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final moviesSlideshow = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    //return const FullScreenLoader();

    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        // backgroundColor: Colors.red,
        titleSpacing: BorderSide.strokeAlignInside,
        title: CustomAppbar(),
        flexibleSpace: FlexibleSpaceBar(
          //title: Icon(Icons.movie_creation_outlined),
          centerTitle: true,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              //const CustomAppbar(),
              MoviesSlideshow(movies: moviesSlideshow),
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Lunes 22',
                loadNextPage: () {
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListview(
                movies: popularMovies,
                title: 'Populares',
                subTitle: 'de todos',
                loadNextPage: () {
                  ref.read(popularMoviesProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListview(
                movies: topRatedMovies,
                title: 'Los mas valorados',
                subTitle: '',
                loadNextPage: () {
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                },
              ),
              MovieHorizontalListview(
                movies: upcomingMovies,
                title: 'Proximamente',
                subTitle: 'en cines',
                loadNextPage: () {
                  ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        }, childCount: 1),
      )
    ]);
  }
}
