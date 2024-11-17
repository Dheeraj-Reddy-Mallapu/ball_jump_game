import 'package:ball_jump/components/ball.dart';
import 'package:ball_jump/components/play_again_btn.dart';
import 'package:ball_jump/components/text_overlay.dart';
import 'package:ball_jump/constants.dart';
import 'package:ball_jump/managers/audio_manager.dart';
import 'package:ball_jump/managers/game_state.dart';
import 'package:ball_jump/managers/obstacle_manager.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';

class BallGame extends FlameGame with TapDetector {
  late BallComponent ball;
  final GameState gameState = GameState();
  late ObstacleManager obstacleManager;
  late TextOverlay textOverlay;
  late PlayAgainButton playAgainButton;
  final AudioManager audioManager = AudioManager();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize audio
    await audioManager.initialize();
    audioManager.playBackgroundMusic();

    // Initialize ball
    final ballSvg = await loadSvg('components/ball.svg');
    ball = BallComponent(
      svg: ballSvg,
      initialPosition: Vector2(size.x / 2, size.y - 200),
    );
    add(ball);

    // Initialize obstacles
    obstacleManager = ObstacleManager();
    await obstacleManager.initialize(this);

    // Initialize text overlay
    textOverlay = TextOverlay();
    add(textOverlay);

    // Initialize play again button
    playAgainButton = PlayAgainButton()
      ..position = Vector2(size.x / 2, size.y / 2 + 50)
      ..size = Vector2(120, 40);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.isGameStarted || gameState.isGameOver) return;

    // Update ball position
    bool hitGround = ball.updatePosition(
      GameConstants.gravity,
      dt,
      size.y,
      size.y / 2,
    );

    if (hitGround) {
      gameOver();
      return;
    }

    // Update world offset and score
    if (ball.position.y < size.y / 2) {
      double overflow = size.y / 2 - ball.position.y;
      gameState.worldOffset += overflow;
      gameState.incrementScore(overflow);
      textOverlay.updateScore(gameState.score);
      obstacleManager.adjustObstaclesForScroll(overflow);
      ball.position.y = size.y / 2;
    }

    // Update and check obstacles
    obstacleManager.update(dt, size.x);
    if (obstacleManager.checkCollisions(ball)) {
      gameOver();
      return;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (gameState.isGameOver) return;

    if (!gameState.isGameStarted) {
      gameState.isGameStarted = true;
      ball.jump(GameConstants.jumpForce);
      textOverlay.showMessage('Tap to Jump!');
      audioManager.playJumpSound();
    } else {
      ball.jump(GameConstants.jumpForce);
      textOverlay.hideMessage();
      audioManager.playJumpSound();
    }
  }

  void gameOver() {
    gameState.isGameStarted = false;
    gameState.isGameOver = true;
    audioManager.playCollisionSound();
    textOverlay.showMessage('Game Over!');
    add(playAgainButton);
  }

  void resetGame() async {
    gameState.reset();
    ball.reset(Vector2(size.x / 2, size.y - 200));
    await obstacleManager.reset(this);
    textOverlay.reset();
    remove(playAgainButton);

    audioManager.playBackgroundMusic();
  }

  @override
  void onRemove() {
    audioManager.stopBackgroundMusic();
    super.onRemove();
  }

  // @override
  // void onPause() {
  //   audioManager.pauseBackgroundMusic();
  //   super.onPause();
  // }

  // @override
  // void onResume() {
  //   audioManager.resumeBackgroundMusic();
  //   super.onResume();
  // }
}
