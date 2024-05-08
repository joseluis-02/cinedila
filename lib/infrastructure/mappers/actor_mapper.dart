import 'package:cinedila/domain/entities/actor.dart';
import 'package:cinedila/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
          : 'https://cdn.pixabay.com/photo/2013/07/13/10/44/man-157699_640.png',
      character: cast.character!);
}
