import 'package:flutter/material.dart';

class SubtleStarField extends StatelessWidget {
  const SubtleStarField({
    this.starCount = 15,
    this.starColor = const Color(0xFFD9D9D9),
    super.key,
  });

  final int starCount;
  final Color starColor;

  static const List<Offset> _starPositions = [
    Offset(0.12, 0.18),
    Offset(0.28, 0.12),
    Offset(0.51, 0.20),
    Offset(0.74, 0.14),
    Offset(0.89, 0.27),
    Offset(0.18, 0.38),
    Offset(0.42, 0.34),
    Offset(0.67, 0.41),
    Offset(0.84, 0.52),
    Offset(0.09, 0.61),
    Offset(0.31, 0.69),
    Offset(0.55, 0.58),
    Offset(0.76, 0.72),
    Offset(0.22, 0.84),
    Offset(0.63, 0.87),
  ];

  static const List<double> _starSizes = [
  3.2,
  2.4,
  2.8,
  2.2,
  2.7,
  2.3,
  3.4,
  2.5,
  2.2,
  2.8,
  2.3,
  3.0,
  2.4,
  2.9,
  2.2,
];

 static const List<double> _starOpacities = [
  0.92,
  0.65,
  0.82,
  0.58,
  0.76,
  0.61,
  0.95,
  0.72,
  0.55,
  0.81,
  0.63,
  0.89,
  0.68,
  0.84,
  0.60,
];

  @override
  Widget build(BuildContext context) {
    final visibleStarCount = starCount.clamp(
      0,
      _starPositions.length,
    );

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: List.generate(
              visibleStarCount,
              (index) {
                final position = _starPositions[index];
                final size = _starSizes[index];
                final opacity = _starOpacities[index];

                return Positioned(
                  left: constraints.maxWidth * position.dx,
                  top: constraints.maxHeight * position.dy,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: starColor.withValues(
                        alpha: opacity,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}