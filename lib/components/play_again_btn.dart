import 'package:ball_jump/ball_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PlayAgainButton extends PositionComponent with TapCallbacks {
  PlayAgainButton() : super(anchor: Anchor.center);

  late final TextPaint _textPaint;
  final _buttonText = 'Play Again';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _textPaint = TextPaint(
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue.withOpacity(0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(18)),
      paint,
    );

    final textSize = _textPaint.getLineMetrics(_buttonText);
    final position = Vector2(
      (size.x - textSize.size.x) / 2,
      (size.y - textSize.size.y) / 2,
    );
    _textPaint.render(canvas, _buttonText, Vector2(position.x, position.y));
  }

  @override
  void onTapDown(TapDownEvent event) {
    final game = findGame()! as BallGame;
    game.resetGame();
  }
}
