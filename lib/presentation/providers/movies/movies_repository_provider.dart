import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinedila/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinedila/infrastructure/repositories/movie_repository_impl.dart';

// Este repositorio es inmutable
// No se puede alterar datos
// Se usa Provider=> Fluter-Riverpod
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});
