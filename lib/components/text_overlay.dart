import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TextOverlay extends Component {
  late TextComponent messageText;
  late TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    messageText = TextComponent(
      text: 'Tap to Start!',
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );

    scoreText = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.5)),
      ),
    );

    scoreText.position = Vector2(10, 30);
    add(scoreText);
    add(messageText);
  }

  void updateScore(int score) {
    scoreText.text = '$score';
  }

  void showMessage(String message) {
    messageText.text = message;
  }

  void hideMessage() {
    messageText.text = '';
  }

  void reset() {
    showMessage('Tap to Start!');
    updateScore(0);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    messageText.position = size / 2 - messageText.size / 2;
  }
}
