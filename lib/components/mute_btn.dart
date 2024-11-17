import 'package:ball_jump/ball_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MuteButton extends PositionComponent with TapCallbacks {
  bool isMuted = false;
  late final TextPaint _textPaint;

  MuteButton() : super(size: Vector2(40, 40), anchor: Anchor.topRight);

  @override
  Future<void> onLoad() async {
    _textPaint = TextPaint(
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );

    _textPaint.render(
      canvas,
      isMuted ? '🔇' : '🔊',
      Vector2(size.x / 2 - 10, size.y / 2 - 10),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    final game = findGame()! as BallGame;
    game.audioManager.toggleMute();
    isMuted = !isMuted;
  }
}
