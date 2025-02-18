import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:personal_cv/actors/player.dart';
import 'package:personal_cv/constants/app_sizes.dart';

enum GameLevel {
  level01(name: 'Level-01');

  final String name;

  const GameLevel({required this.name});
}

class Level extends World {
  final GameLevel gameLevel;
  final Player player;
  Level({required this.gameLevel,required this.player});


  late TiledComponent level;


  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '${gameLevel.name}.tmx',
      Vector2.all(AppSizes.tileSize),
    );
    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final spawnpoint in spawnPointsLayer!.objects) {
      switch (spawnpoint.class_) {
        case 'Player':
          player.position = Vector2(spawnpoint.x, spawnpoint.y);
          add(player);
          break;
        default:
          break;
      }
    }
    return super.onLoad();
  }
}
