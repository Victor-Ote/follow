import 'package:flutter/material.dart';
import '../../data/universe_star.dart';

class UniversePainter extends CustomPainter {
  UniversePainter({
    required this.stars,
    required this.starOpacities,
    required this.panOffset,
    required this.scale,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<UniverseStar> stars;
  final Map<String, double> starOpacities;
  final Offset panOffset;
  final double scale;
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

      if (opacity <= 0) {
        continue;
      }

      final starPosition = Offset(star.x, star.y);

      if (!visibleUniverseRect.contains(starPosition)) {
        continue;
      }

      _drawStar(
        canvas: canvas,
        star: star,
        position: starPosition,
        opacity: opacity,
      );
    }

    canvas.restore();
  }

  void _drawStar({
    required Canvas canvas,
    required UniverseStar star,
    required Offset position,
    required double opacity,
  }) {
    final starRadius = star.size / 2;

    final outerHaloPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..style = PaintingStyle.fill;

    final innerHaloPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, starRadius * 3, outerHaloPaint);

    canvas.drawCircle(position, starRadius * 1.7, innerHaloPaint);

    canvas.drawCircle(position, starRadius, corePaint);
  }

  @override
  bool shouldRepaint(covariant UniversePainter oldDelegate) {
    return oldDelegate.stars != stars ||
        oldDelegate.starOpacities != starOpacities ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.scale != scale;
  }
}
