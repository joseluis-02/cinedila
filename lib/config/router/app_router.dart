import 'package:cinedila/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:view',
      name: HomeScreen.name,
      builder: (context, state) {
        //Recibimos el index del view desde la url
        final viewIndex = state.pathParameters['view'] ?? '0';
        return HomeScreen(
          viewIndex: int.parse(viewIndex),
        );
      },
      routes: [
        GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id';
              return MovieScreen(
                movieId: movieId,
              );
            }),
      ]),
  GoRoute(
    path: '/',
    redirect: (_, __) => '/home/0',
  ),
]);
