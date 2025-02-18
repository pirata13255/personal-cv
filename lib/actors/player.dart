import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:personal_cv/personal_cv.dart';
import '../constants/app_sizes.dart';

enum Character {
  maskDude(name: 'Mask Dude'),
  ninjaFrog(name: 'Ninja Frog'),
  pinkMan(name: 'Pink Man'),
  virtualGuy(name: 'Virtual Guy'),
  ;

  final String name;

  const Character({required this.name});
}

enum PlayerState {
  doubleJump(asset: 'Double Jump'),
  fall(asset: 'Fall'),
  hit(asset: 'Hit'),
  idle(asset: 'Idle'),
  jump(asset: 'Jump'),
  run(asset: 'Run'),
  wallJump(asset: 'Wall Jump');

  final String asset;

  const PlayerState({required this.asset});
}

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PersonalCv>, KeyboardHandler {
  Character character;

  Player({
    position,
    this.character = Character.maskDude,
  }) : super(position: position);

  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if(isLeftKeyPressed && isRightKeyPressed){
      playerDirection = PlayerDirection.none;
    }else if(isLeftKeyPressed){
      playerDirection = PlayerDirection.left;
    }else if(isRightKeyPressed){
      playerDirection = PlayerDirection.right;
    }else{
      playerDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.run;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.run;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
        break;
    }
    velocity = Vector2(dirX, 0);
    position += velocity * dt;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/${character.name}/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: AppSizes.stepTime,
        textureSize: Vector2.all(AppSizes.textureSize),
      ),
    );
  }

  Future<void> _loadAllAnimations() async {
    idleAnimation = _spriteAnimation(
      PlayerState.idle.asset,
      11,
    );

    runAnimation = _spriteAnimation(
      PlayerState.run.asset,
      12,
    );

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
    };

    // Set the animation
    current = PlayerState.idle;
  }
}
