import 'package:ball_jump/constants.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class BallComponent extends SvgComponent {
  double velocity = 0;

  BallComponent({
    required Svg super.svg,
    required Vector2 initialPosition,
  }) : super(
          size: Vector2.all(GameConstants.ballSize),
          position: initialPosition,
          anchor: Anchor.center,
        );

  void jump(double force) {
    velocity = force;
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += 0.025;
  }

  bool updatePosition(
      double gravity, double dt, double screenHeight, double halfScreen) {
    velocity += gravity;
    position.y += velocity;

    if (position.y > screenHeight - 75) {
      position.y = screenHeight - 75;
      velocity = 0;
      return true;
    }
    return false;
  }

  void reset(Vector2 position) {
    this.position = position;
    velocity = 0;
    angle = 0;
  }
}
