import 'dart:math';

import 'package:ball_jump/ball_game.dart';
import 'package:ball_jump/components/obstacle.dart';
import 'package:ball_jump/constants.dart';
import 'package:ball_jump/utils/collision_utils.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class ObstacleManager {
  final List<Obstacle> obstacles = [];
  final Random random = Random();

  Future<void> initialize(BallGame game) async {
    await addRandomObstacle(game, y: random.nextDouble() * 200);
    await addRandomObstacle(game, y: random.nextDouble() * 200);
    await addRandomObstacle(game, y: (random.nextDouble() * 200) + 100);
    await addRandomObstacle(game, y: (random.nextDouble() * 300) + 100);
  }

  Future<void> addRandomObstacle(BallGame game, {double? y}) async {
    String obstacleName = '${random.nextInt(5) + 1}';
    final objectSvg =
        await game.loadSvg('components/obstacles/$obstacleName.svg');
    final yPosition = -(random.nextDouble() * 200);

    final object = Obstacle(
      svg: objectSvg,
      position: Vector2(
        random.nextBool() ? -GameConstants.obstacleSize : game.size.x,
        y ?? yPosition,
      ),
      speed: random.nextDouble() *
              (GameConstants.maxObstacleSpeed -
                  GameConstants.minObstacleSpeed) +
          GameConstants.minObstacleSpeed,
      movingRight: random.nextBool(),
    );

    obstacles.add(object);
    game.add(object);
  }

  void update(double dt, double screenWidth) {
    for (var obstacle in obstacles) {
      obstacle.move(dt, screenWidth);
    }

    if (!obstacles.any((element) => element.position.y < 0)) {
      addRandomObstacle(obstacles.first.game);
    }
  }

  bool checkCollisions(SvgComponent ball) {
    for (var obstacle in obstacles) {
      if (CollisionUtils.checkCollision(
        ball,
        obstacle,
        GameConstants.collisionReductionBall,
        GameConstants.collisionReductionObstacle,
      )) {
        return true;
      }
    }
    return false;
  }

  void adjustObstaclesForScroll(double amount) {
    for (var object in obstacles) {
      object.position.y += amount;
    }

    // Remove obstacles that are too far below the screen
    final outOfBounds = obstacles
        .where((object) => object.position.y > object.game.size.y)
        .toList();

    for (var obstacle in outOfBounds) {
      obstacle.removeFromParent();
      obstacles.remove(obstacle);
    }
  }

  Future<void> reset(BallGame game) async {
    for (var obstacle in obstacles) {
      game.remove(obstacle);
    }
    obstacles.clear();
    await initialize(game);
  }
}
