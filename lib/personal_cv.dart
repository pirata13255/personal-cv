import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:personal_cv/levels/level.dart';
import 'actors/player.dart';
import 'constants/app_colors.dart';
import 'constants/app_images.dart';
import 'constants/app_sizes.dart';

class PersonalCv extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => AppColors.backgroundColor;
  late final CameraComponent cam;
  Player player = Player(character: Character.ninjaFrog);
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(player: player, gameLevel: GameLevel.level01);
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: AppSizes.gameWidth,
      height: AppSizes.gameHeight,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    cam.priority = 0;
    addAll([cam, world]);
    if(showJoystick){
      addJoystick();
    }
    return await super.onLoad();
  }

  @override
  void update(double dt){
    if(showJoystick){
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache(AppImages.joystickBackground),
        ),
      ),
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache(AppImages.joystickKnob),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 32,
        bottom: 32,
      ),
    );
    joystick.priority = 10;
    camera.viewport.add(joystick);
  }

  void updateJoystick() {
    switch(joystick.direction){
      case JoystickDirection.upLeft:
      case JoystickDirection.left:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
      case JoystickDirection.upRight:
      case JoystickDirection.right:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
      default:
        player.horizontalMovement = 0;
    }
  }
}


