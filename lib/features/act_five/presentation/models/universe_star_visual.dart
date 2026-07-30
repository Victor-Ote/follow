import 'package:flutter/material.dart';

class UniverseStarVisual {
  const UniverseStarVisual({
    required this.size,
    required this.color,
    required this.twinkles,
    required this.minimumOpacity,
    required this.twinklePhase,
    required this.twinkleCycles,
  });

  /// Tamanho visual sorteado para esta abertura.
  final double size;

  /// Temperatura de cor visual da estrela.
  final Color color;

  /// Define se a estrela possui pulsação constante.
  final bool twinkles;

  /// Menor opacidade alcançada durante a pulsação.
  final double minimumOpacity;

  /// Posição inicial dentro do ciclo de pulsação.
  final double twinklePhase;

  /// Quantidade de pulsações durante um ciclo completo.
  final double twinkleCycles;
}