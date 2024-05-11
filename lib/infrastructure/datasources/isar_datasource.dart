import 'package:isar/isar.dart';
import 'package:cinedila/domain/datasources/local_storage_datasource.dart';
import 'package:cinedila/domain/entities/movie.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }
  //Metodo para verificar el estado de la base de datos
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema],
          directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;
    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();
    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  /*Future<void> toggleFavorite(Movie movie) async {
    //Transacciones a la base de datos
    final isar = await db;
    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();
    if (favoriteMovie != null) {
      //Ya tenemos en favorito
      //Podemos quitar de favoritos
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
    }
    //si no se encuentra en nuestro favorito podemos insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }*/
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;
    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();
    if (favoriteMovie != null) {
      // La película ya está en favoritos, la eliminamos
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
    } else {
      // La película no está en favoritos, la agregamos
      isar.writeTxnSync(() => isar.movies.putSync(movie));
    }
  }
}
