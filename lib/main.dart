import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:personal_cv/personal_cv.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PersonalCv game = PersonalCv();

  runApp(
    GameWidget(
      game: game,
    ),
  );
}