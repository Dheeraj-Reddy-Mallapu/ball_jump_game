import 'dart:ui';

import 'package:flame_svg/flame_svg.dart';

class CollisionUtils {
  static bool checkCollision(
    SvgComponent a,
    SvgComponent b,
    double reductionA,
    double reductionB,
  ) {
    final rectA = a.toRect();
    final rectB = b.toRect();

    final reducedRectA = _reduceCollisionSize(rectA, reductionA);
    final reducedRectB = _reduceCollisionSize(rectB, reductionB);

    return reducedRectA.overlaps(reducedRectB);
  }

  static Rect _reduceCollisionSize(Rect rect, double reductionFactor) {
    return Rect.fromLTWH(
      rect.left + rect.width * reductionFactor,
      rect.top + rect.height * reductionFactor,
      rect.width * (1 - reductionFactor * 2),
      rect.height * (1 - reductionFactor * 2),
    );
  }
}
