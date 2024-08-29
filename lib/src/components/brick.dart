import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required super.position, required Color color})
      : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    final brick1 = RectangleComponent(
      position: position + Vector2(-5, -5), // Slightly offset to simulate glitch
      size: size,
      paint: paint..color = Colors.red.withOpacity(0.8), 
      anchor: Anchor.center,
    );

    final brick2 = RectangleComponent(
      position: position + Vector2(5, 5), // Slightly offset to simulate glitch
      size: size,
      paint: paint..color = Colors.blue.withOpacity(0.8), 
      anchor: Anchor.center,
    );

    brick1.add(OpacityEffect.fadeOut(
      EffectController(duration: 0.2),
      onComplete: () => brick1.removeFromParent(),
    ));
    brick2.add(OpacityEffect.fadeOut(
      EffectController(duration: 0.2),
      onComplete: () => brick2.removeFromParent(),
    ));
    game.world.add(brick1);
    game.world.add(brick2);

    add(OpacityEffect.fadeOut(
      EffectController(duration: 0.2), 
      onComplete: () {
        removeFromParent(); 
        game.score.value++;
      },
    ));
  }
}
