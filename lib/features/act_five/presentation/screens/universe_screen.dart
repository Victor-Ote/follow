import 'package:flutter/material.dart';

import '../painters/universe_painter.dart';
import '../../data/universe_stars_data.dart';
import '../models/universe_star_visual.dart';
import 'universe_final_screen.dart';

import '../../data/universe_star.dart';
import '../widgets/star_moment_overlay.dart';

import 'dart:math' as math;

class UniverseScreen extends StatefulWidget {
  const UniverseScreen({this.onFinished, super.key});

  final VoidCallback? onFinished;

  @override
  State<UniverseScreen> createState() => _UniverseScreenState();
}

class _UniverseScreenState extends State<UniverseScreen>
    with SingleTickerProviderStateMixin {
  static const double _minimumScale = 0.65;
  static const double _maximumScale = 2.60;
  static const Duration _turnPageButtonFadeDuration = Duration(
    milliseconds: 900,
  );
  static const int _starsRequiredToTurnPage = 3;

  static const Duration _screenFadeOutDuration = Duration(milliseconds: 1600);

  static const List<Color> _starColorPalette = [
    // Branco neutro — aparece mais vezes.
    Color(0xFFF4F4F1),
    Color(0xFFF4F4F1),
    Color(0xFFF7F5EE),

    // Azul muito discreto.
    Color(0xFFD6E9FF),
    Color(0xFFC9E1FF),

    // Amarelo e dourado muito suaves.
    Color(0xFFFFE7B8),
    Color(0xFFF8EED7),
  ];

  static const List<double> _twinkleCycleOptions = [1, 2, 3, 4, 5, 6];

  static const double _universeEdgePadding = 50; //tamanho da borda do universo

  static const int _initialVisibleStarCount = 7;

  static const int _maximumStarsPerDiscovery = 10;

  static const Duration _starFadeDuration = Duration(milliseconds: 720);

  static const double _discoveryViewportMargin = 90;

  static const double _minimumDiscoveryMovement = 120;

  static const double _minimumDiscoveryScaleDifference = 0.16;

  Offset _panOffset = Offset.zero;
  double _scale = 1;
  final Set<String> _openedStarIds = {};

  bool _turnPageButtonMounted = false;
  bool _turnPageButtonVisible = false;

  bool _screenVisible = true;
  bool _isLeaving = false;

  late final Map<String, UniverseStarVisual> _starVisuals;

  UniverseStar? _selectedStar;
  bool _selectedStarModalBelow = false;

  late final AnimationController _starFadeController;

  final Stopwatch _starFadeClock = Stopwatch();

  final Set<String> _revealedStarIds = {};

  final Map<String, double> _starOpacities = {};

  final Map<String, Duration> _starRevealStartedAt = {};

  bool _initialRevealScheduled = false;

  Offset? _lastDiscoveryUniverseCenter;
  double? _lastDiscoveryScale;

  double _gestureStartScale = 1;
  Offset _gestureStartUniversePoint = Offset.zero;

  Map<String, UniverseStarVisual> _createRandomStarVisuals() {
    if (universeStars.isEmpty) {
      return {};
    }

    final random = math.Random();

    /*
   * Em cada abertura, sorteamos entre
   * aproximadamente 30% e 45% das estrelas
   * para receberem pulsação.
   */
    final shuffledStars = [...universeStars]..shuffle(random);

    final minimumTwinkleCount = math.max(
      1,
      (universeStars.length * 0.30).round(),
    );

    final maximumTwinkleCount = math.min(
      universeStars.length,
      math.max(minimumTwinkleCount, (universeStars.length * 0.45).round()),
    );

    final twinkleCount =
        minimumTwinkleCount +
        random.nextInt(maximumTwinkleCount - minimumTwinkleCount + 1);

    final twinklingStarIds = shuffledStars
        .take(twinkleCount)
        .map((star) => star.id)
        .toSet();

    final visuals = <String, UniverseStarVisual>{};

    for (final star in universeStars) {
      final twinkles = twinklingStarIds.contains(star.id);

      visuals[star.id] = UniverseStarVisual(
        size: (star.size * (1.35 + random.nextDouble() * 0.85))
            .clamp(3.4, 8.8)
            .toDouble(),

        color: _starColorPalette[random.nextInt(_starColorPalette.length)],

        twinkles: twinkles,

        /*
       * As estrelas pulsantes poderão cair
       * entre 22% e 50% da opacidade máxima.
       *
       * As estrelas estáticas permanecem em 100%.
       */
        minimumOpacity: twinkles ? 0.22 + random.nextDouble() * 0.28 : 1,

        twinklePhase: random.nextDouble() * math.pi * 2,

        twinkleCycles:
            _twinkleCycleOptions[random.nextInt(_twinkleCycleOptions.length)],
      );
    }

    return visuals;
  }

  @override
  void initState() {
    super.initState();

    _starVisuals = _createRandomStarVisuals();

    _starFadeClock.start();

    /*
   * Este controlador passa a funcionar como
   * relógio tanto do fade de descoberta quanto
   * do brilho constante das estrelas.
   */
    _starFadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _starFadeController.addListener(_updateStarFades);

    _starFadeController.repeat();
  }

  @override
  void dispose() {
    _starFadeController.removeListener(_updateStarFades);

    _starFadeController.dispose();
    _starFadeClock.stop();

    super.dispose();
  }

  Rect _universeRectForViewport({
    required Size viewportSize,
    required Offset panOffset,
    required double scale,
  }) {
    final viewportCenter = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );

    return Rect.fromLTRB(
      (-viewportCenter.dx - panOffset.dx) / scale,
      (-viewportCenter.dy - panOffset.dy) / scale,
      (viewportSize.width - viewportCenter.dx - panOffset.dx) / scale,
      (viewportSize.height - viewportCenter.dy - panOffset.dy) / scale,
    ).inflate(_discoveryViewportMargin / scale);
  }

  Offset _currentUniverseCenter({
    required Offset panOffset,
    required double scale,
  }) {
    return Offset(-panOffset.dx / scale, -panOffset.dy / scale);
  }

  Rect? _calculateStarsBounds() {
    if (universeStars.isEmpty) {
      return null;
    }

    var minimumX = universeStars.first.x;
    var maximumX = universeStars.first.x;
    var minimumY = universeStars.first.y;
    var maximumY = universeStars.first.y;

    for (final star in universeStars.skip(1)) {
      if (star.x < minimumX) {
        minimumX = star.x;
      }

      if (star.x > maximumX) {
        maximumX = star.x;
      }

      if (star.y < minimumY) {
        minimumY = star.y;
      }

      if (star.y > maximumY) {
        maximumY = star.y;
      }
    }

    return Rect.fromLTRB(minimumX, minimumY, maximumX, maximumY);
  }

  Offset _constrainPanOffset({
    required Offset proposedPanOffset,
    required Size viewportSize,
    required double scale,
  }) {
    final starsBounds = _calculateStarsBounds();

    if (starsBounds == null) {
      return Offset.zero;
    }

    final horizontalViewportRadius = viewportSize.width / 2;

    final verticalViewportRadius = viewportSize.height / 2;

    /*
   * A margem é convertida para coordenadas
   * do universo para permanecer visualmente
   * semelhante em todos os níveis de zoom.
   */
    final universePadding = _universeEdgePadding / scale;

    final universeBounds = Rect.fromLTRB(
      starsBounds.left - universePadding,
      starsBounds.top - universePadding,
      starsBounds.right + universePadding,
      starsBounds.bottom + universePadding,
    );

    final minimumPanX = horizontalViewportRadius - universeBounds.right * scale;

    final maximumPanX = -horizontalViewportRadius - universeBounds.left * scale;

    final minimumPanY = verticalViewportRadius - universeBounds.bottom * scale;

    final maximumPanY = -verticalViewportRadius - universeBounds.top * scale;

    final constrainedX = minimumPanX <= maximumPanX
        ? proposedPanOffset.dx.clamp(minimumPanX, maximumPanX).toDouble()
        : (minimumPanX + maximumPanX) / 2;

    final constrainedY = minimumPanY <= maximumPanY
        ? proposedPanOffset.dy.clamp(minimumPanY, maximumPanY).toDouble()
        : (minimumPanY + maximumPanY) / 2;

    return Offset(constrainedX, constrainedY);
  }

  Offset _screenPointToUniverse({
    required Offset screenPoint,
    required Size viewportSize,
    required Offset panOffset,
    required double scale,
  }) {
    final viewportCenter = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );

    return (screenPoint - viewportCenter - panOffset) / scale;
  }

  Offset _universePointToScreen({
    required Offset universePoint,
    required Size viewportSize,
  }) {
    final viewportCenter = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );

    return viewportCenter + _panOffset + (universePoint * _scale);
  }

  void _handleStarTap({
    required TapUpDetails details,
    required Size viewportSize,
  }) {
    UniverseStar? closestStar;
    double? closestDistance;

    for (final star in universeStars) {
      if (!_revealedStarIds.contains(star.id)) {
        continue;
      }

      final opacity = _starOpacities[star.id] ?? 0;

      /*
     * Uma estrela ainda no início do fade
     * não será clicável.
     */
      if (opacity < 0.35) {
        continue;
      }

      final screenPosition = _universePointToScreen(
        universePoint: Offset(star.x, star.y),
        viewportSize: viewportSize,
      );

      final distance = (details.localPosition - screenPosition).distance;

      final scaledVisualRadius = star.size * _scale * 3.5;

      /*
     * Mantemos uma área mínima de toque
     * para estrelas visualmente pequenas.
     */
      final hitRadius = scaledVisualRadius < 18 ? 18.0 : scaledVisualRadius;

      if (distance > hitRadius) {
        continue;
      }

      if (closestDistance == null || distance < closestDistance) {
        closestStar = star;
        closestDistance = distance;
      }
    }

    if (closestStar == null) {
      return;
    }

    final selectedStarScreenPosition = _universePointToScreen(
      universePoint: Offset(closestStar.x, closestStar.y),
      viewportSize: viewportSize,
    );

    /*
 * Caso a estrela esteja muito próxima do topo
 * no momento do clique, o modal nasce abaixo.
 *
 * Essa escolha permanece fixa enquanto aquele
 * modal estiver aberto.
 */
    final shouldPlaceBelow =
        selectedStarScreenPosition.dy < viewportSize.height * 0.32;

    final isNewlyOpenedStar = _openedStarIds.add(closestStar.id);

    final shouldUnlockTurnPage =
        isNewlyOpenedStar &&
        !_turnPageButtonMounted &&
        _openedStarIds.length >= _starsRequiredToTurnPage;

    setState(() {
      _selectedStar = closestStar;
      _selectedStarModalBelow = shouldPlaceBelow;

      if (shouldUnlockTurnPage) {
        /*
     * Primeiro inserimos o botão invisível
     * na árvore de widgets.
     */
        _turnPageButtonMounted = true;
      }
    });

    if (shouldUnlockTurnPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _isLeaving || _turnPageButtonVisible) {
          return;
        }

        setState(() {
          /*
       * No frame seguinte alteramos a opacidade,
       * garantindo que o fade seja executado.
       */
          _turnPageButtonVisible = true;
        });
      });
    }
  }

  void _closeSelectedStar() {
    if (_selectedStar == null) {
      return;
    }

    setState(() {
      _selectedStar = null;
      _selectedStarModalBelow = false;
    });
  }

  Future<void> _finishAct() async {
    if (_isLeaving || !_turnPageButtonVisible) {
      return;
    }

    setState(() {
      _isLeaving = true;
      _screenVisible = false;
    });

    await Future<void>.delayed(_screenFadeOutDuration);

    if (!mounted) {
      return;
    }

    /*
   * Quando um fluxo externo fornecer callback,
   * ele continuará tendo prioridade.
   */
    if (widget.onFinished != null) {
      widget.onFinished!.call();
      return;
    }

    /*
   * Quando UniverseScreen estiver sendo usada
   * diretamente, avançamos para a tela final.
   *
   * Não adicionamos outra transição porque
   * o universo já terminou completamente preto.
   */
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const UniverseFinalScreen();
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _updateStarFades() {
    /*
   * Mesmo sem estrelas executando o fade
   * inicial, não paramos o controlador.
   *
   * Ele também é responsável pelo brilho
   * constante das estrelas.
   */
    if (_starRevealStartedAt.isEmpty) {
      return;
    }

    final now = _starFadeClock.elapsed;
    final completedStarIds = <String>[];

    for (final entry in _starRevealStartedAt.entries) {
      final elapsed = now - entry.value;

      final rawProgress =
          elapsed.inMicroseconds / _starFadeDuration.inMicroseconds;

      final progress = rawProgress.clamp(0.0, 1.0);

      _starOpacities[entry.key] = Curves.easeInOut.transform(progress);

      if (rawProgress >= 1) {
        completedStarIds.add(entry.key);
      }
    }

    for (final starId in completedStarIds) {
      _starOpacities[starId] = 1;
      _starRevealStartedAt.remove(starId);
    }

    /*
   * Não adicionar _starFadeController.stop()
   * neste método.
   */
  }

  void _revealStars(Iterable<dynamic> stars) {
    final revealStartedAt = _starFadeClock.elapsed;

    var addedAnyStar = false;

    for (final star in stars) {
      final wasAdded = _revealedStarIds.add(star.id);

      if (!wasAdded) {
        continue;
      }

      _starOpacities[star.id] = 0;
      _starRevealStartedAt[star.id] = revealStartedAt;

      addedAnyStar = true;
    }

    if (addedAnyStar && !_starFadeController.isAnimating) {
      _starFadeController.repeat();
    }
  }

  void _revealInitialStars(Size viewportSize) {
    final visibleRect = _universeRectForViewport(
      viewportSize: viewportSize,
      panOffset: _panOffset,
      scale: _scale,
    );

    final universeCenter = _currentUniverseCenter(
      panOffset: _panOffset,
      scale: _scale,
    );

    final candidates =
        universeStars
            .where((star) => visibleRect.contains(Offset(star.x, star.y)))
            .toList()
          ..sort((first, second) {
            final firstDistance =
                (Offset(first.x, first.y) - universeCenter).distanceSquared;

            final secondDistance =
                (Offset(second.x, second.y) - universeCenter).distanceSquared;

            return firstDistance.compareTo(secondDistance);
          });

    _revealStars(candidates.take(_initialVisibleStarCount));

    _lastDiscoveryUniverseCenter = universeCenter;

    _lastDiscoveryScale = _scale;
  }

  void _scheduleInitialReveal(Size viewportSize) {
    if (_initialRevealScheduled) {
      return;
    }

    _initialRevealScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _revealInitialStars(viewportSize);
    });
  }

  void _discoverStarsForViewport({
    required Size viewportSize,
    required Offset panOffset,
    required double scale,
  }) {
    final universeCenter = _currentUniverseCenter(
      panOffset: panOffset,
      scale: scale,
    );

    final lastCenter = _lastDiscoveryUniverseCenter;

    final lastScale = _lastDiscoveryScale;

    final movementThreshold = _minimumDiscoveryMovement / scale;

    final movedEnough =
        lastCenter == null ||
        (universeCenter - lastCenter).distance >= movementThreshold;

    final scaleChangedEnough =
        lastScale == null ||
        (scale - lastScale).abs() >= _minimumDiscoveryScaleDifference;

    if (!movedEnough && !scaleChangedEnough) {
      return;
    }

    _lastDiscoveryUniverseCenter = universeCenter;

    _lastDiscoveryScale = scale;

    final visibleRect = _universeRectForViewport(
      viewportSize: viewportSize,
      panOffset: panOffset,
      scale: scale,
    );

    final candidates =
        universeStars.where((star) {
          if (_revealedStarIds.contains(star.id)) {
            return false;
          }

          return visibleRect.contains(Offset(star.x, star.y));
        }).toList()..sort((first, second) {
          final firstDistance =
              (Offset(first.x, first.y) - universeCenter).distanceSquared;

          final secondDistance =
              (Offset(second.x, second.y) - universeCenter).distanceSquared;

          return firstDistance.compareTo(secondDistance);
        });

    _revealStars(candidates.take(_maximumStarsPerDiscovery));
  }

  void _handleScaleStart(ScaleStartDetails details, Size viewportSize) {
    _gestureStartScale = _scale;

    _gestureStartUniversePoint = _screenPointToUniverse(
      screenPoint: details.localFocalPoint,
      viewportSize: viewportSize,
      panOffset: _panOffset,
      scale: _scale,
    );
  }

  void _handleScaleUpdate(ScaleUpdateDetails details, Size viewportSize) {
    final nextScale = (_gestureStartScale * details.scale)
        .clamp(_minimumScale, _maximumScale)
        .toDouble();

    final viewportCenter = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );

    final proposedPanOffset =
        details.localFocalPoint -
        viewportCenter -
        (_gestureStartUniversePoint * nextScale);

    final nextPanOffset = _constrainPanOffset(
      proposedPanOffset: proposedPanOffset,
      viewportSize: viewportSize,
      scale: nextScale,
    );

    if (nextScale == _scale && nextPanOffset == _panOffset) {
      return;
    }

    setState(() {
      _scale = nextScale;
      _panOffset = nextPanOffset;
    });

    _discoverStarsForViewport(
      viewportSize: viewportSize,
      panOffset: nextPanOffset,
      scale: nextScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _screenVisible ? 1 : 0,
        duration: _screenFadeOutDuration,
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: _isLeaving,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewportSize = Size(
                constraints.maxWidth,
                constraints.maxHeight,
              );

              _scheduleInitialReveal(viewportSize);

              final selectedStar = _selectedStar;
              final selectedStarScreenPosition = selectedStar != null
                  ? _universePointToScreen(
                      universePoint: Offset(selectedStar.x, selectedStar.y),
                      viewportSize: viewportSize,
                    )
                  : null;
              final modalScale = (_scale / _maximumScale)
                  .clamp(0.0, 1.0)
                  .toDouble();
              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) {
                        _handleStarTap(
                          details: details,
                          viewportSize: viewportSize,
                        );
                      },
                      onScaleStart: (details) {
                        _handleScaleStart(details, viewportSize);
                      },
                      onScaleUpdate: (details) {
                        _handleScaleUpdate(details, viewportSize);
                      },
                      child: RepaintBoundary(
                        child: ClipRect(
                          child: CustomPaint(
                            painter: UniversePainter(
                              stars: universeStars,
                              starVisuals: _starVisuals,
                              starOpacities: _starOpacities,
                              panOffset: _panOffset,
                              scale: _scale,
                              skyAnimation: _starFadeController,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (selectedStar != null &&
                      selectedStarScreenPosition != null)
                    Positioned.fill(
                      child: StarMomentOverlay(
                        star: selectedStar,
                        anchor: selectedStarScreenPosition,
                        modalScale: modalScale,
                        placeBelow: _selectedStarModalBelow,
                        onClose: _closeSelectedStar,
                      ),
                    ),
                  if (_turnPageButtonMounted)
                    Positioned(
                      right: 18 + MediaQuery.viewPaddingOf(context).right,
                      bottom: 18 + MediaQuery.viewPaddingOf(context).bottom,
                      child: IgnorePointer(
                        ignoring: !_turnPageButtonVisible || _isLeaving,
                        child: AnimatedOpacity(
                          opacity: _turnPageButtonVisible ? 1 : 0,
                          duration: _turnPageButtonFadeDuration,
                          curve: Curves.easeInOut,
                          child: FilledButton(
                            onPressed: _isLeaving ? null : _finishAct,
                            style: FilledButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text(
                              'Virar a página',
                              style: TextStyle(
                                fontFamily: 'CookieFont',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
