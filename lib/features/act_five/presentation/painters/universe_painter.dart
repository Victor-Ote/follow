import 'package:flutter/material.dart';
import '../../data/universe_star.dart';
import '../models/universe_star_visual.dart';
import 'dart:math' as math;

class UniversePainter extends CustomPainter {
  UniversePainter({
    required this.stars,
    required this.starVisuals,
    required this.starOpacities,
    required this.panOffset,
    required this.scale,
    required this.skyAnimation,
  }) : super(repaint: skyAnimation);

  final List<UniverseStar> stars;

  final Map<String, UniverseStarVisual> starVisuals;

  final Map<String, double> starOpacities;

  final Offset panOffset;
  final double scale;

  final Animation<double> skyAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final viewportCenter = Offset(size.width / 2, size.height / 2);

    canvas.save();

    canvas.translate(
      viewportCenter.dx + panOffset.dx,
      viewportCenter.dy + panOffset.dy,
    );

    canvas.scale(scale);

    final visibleUniverseRect = Rect.fromLTRB(
      (-viewportCenter.dx - panOffset.dx) / scale,
      (-viewportCenter.dy - panOffset.dy) / scale,
      (size.width - viewportCenter.dx - panOffset.dx) / scale,
      (size.height - viewportCenter.dy - panOffset.dy) / scale,
    ).inflate(40 / scale);

    for (final star in stars) {
      final opacity = starOpacities[star.id] ?? 0;

      final visual = starVisuals[star.id];

      if (opacity <= 0 || visual == null) {
        continue;
      }

      final starPosition = Offset(star.x, star.y);

      if (!visibleUniverseRect.contains(starPosition)) {
        continue;
      }

      _drawStar(
        canvas: canvas,
        star: star,
        visual: visual,
        position: starPosition,
        opacity: opacity,
      );
    }

    canvas.restore();
  }

  void _drawStar({
    required Canvas canvas,
    required UniverseStar star,
    required UniverseStarVisual visual,
    required Offset position,
    required double opacity,
  }) {
    final revealOpacity = opacity.clamp(0.0, 1.0);

    var twinkleOpacity = 1.0;

    if (visual.twinkles) {
      final angle =
          (skyAnimation.value * math.pi * 2 * visual.twinkleCycles) +
          visual.twinklePhase;

      /*
     * Converte o seno de -1...1 para 0...1.
     */
      final normalizedPulse = (math.sin(angle) + 1) / 2;

      final easedPulse = Curves.easeInOut.transform(normalizedPulse);

      twinkleOpacity =
          visual.minimumOpacity + (1 - visual.minimumOpacity) * easedPulse;
    }

    final combinedOpacity = (revealOpacity * twinkleOpacity).clamp(0.0, 1.0);

    final haloIntensity = visual.twinkles ? 0.60 + twinkleOpacity * 0.40 : 1.0;

    final starRadius = visual.size / 2;

    final outerHaloPaint = Paint()
      ..color = visual.color.withValues(
        alpha: 0.085 * combinedOpacity * haloIntensity,
      )
      ..style = PaintingStyle.fill;

    final innerHaloPaint = Paint()
      ..color = visual.color.withValues(
        alpha: 0.22 * combinedOpacity * haloIntensity,
      )
      ..style = PaintingStyle.fill;

    final corePaint = Paint()
      ..color = visual.color.withValues(alpha: 0.94 * combinedOpacity)
      ..style = PaintingStyle.fill;

    final centralLightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.76 * combinedOpacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, starRadius * 3.2, outerHaloPaint);

    canvas.drawCircle(position, starRadius * 1.75, innerHaloPaint);

    canvas.drawCircle(position, starRadius, corePaint);

    /*
   * Pequeno núcleo branco, preservando a
   * aparência luminosa mesmo nas estrelas
   * azuladas ou amareladas.
   */
    canvas.drawCircle(position, starRadius * 0.34, centralLightPaint);
  }

  @override
  bool shouldRepaint(covariant UniversePainter oldDelegate) {
    return oldDelegate.stars != stars ||
        oldDelegate.starVisuals != starVisuals ||
        oldDelegate.starOpacities != starOpacities ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.scale != scale;
  }
}
