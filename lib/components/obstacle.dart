import 'package:ball_jump/ball_game.dart';
import 'package:ball_jump/constants.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class Obstacle extends SvgComponent with HasGameRef<BallGame> {
  final double speed;
  final bool movingRight;

  Obstacle({
    required Svg svg,
    required Vector2 position,
    required this.speed,
    required this.movingRight,
  }) : super(
          svg: svg,
          size: Vector2.all(GameConstants.obstacleSize),
          position: position,
        );

  void move(double dt, double screenWidth) {
    if (movingRight) {
      position.x += speed * dt;
      if (position.x > screenWidth) {
        position.x = -size.x;
      }
    } else {
      position.x -= speed * dt;
      if (position.x < -size.x) {
        position.x = screenWidth;
      }
    }
  }
}
