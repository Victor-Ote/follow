import 'package:flutter/material.dart';

import '../../data/universe_star.dart';

class StarMomentOverlay extends StatelessWidget {
  const StarMomentOverlay({
    required this.star,
    required this.anchor,
    required this.safePadding,
    required this.onClose,
    super.key,
  });

  final UniverseStar star;

  /// Posição da estrela em coordenadas da tela.
  final Offset anchor;

  final EdgeInsets safePadding;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _StarMomentLayoutDelegate(
        anchor: anchor,
        safePadding: safePadding,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            12,
            18,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0B0B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.16,
              ),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.88,
                ),
                blurRadius: 22,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _MomentInformation(
                            label: 'Data',
                            value: star.date,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MomentInformation(
                            label: 'Horário',
                            value: star.time,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      onPressed: onClose,
                      padding: EdgeInsets.zero,
                      tooltip: 'Fechar',
                      icon: Icon(
                        Icons.close_rounded,
                        size: 21,
                        color: Colors.white.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 1,
                color: Colors.white.withValues(
                  alpha: 0.09,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Mensagem',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                      fontFamily: 'CookieFont',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(
                        alpha: 0.58,
                      ),
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                star.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontFamily: 'CookieFont',
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                      color: Colors.white.withValues(
                        alpha: 0.90,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MomentInformation extends StatelessWidget {
  const _MomentInformation({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(
                fontFamily: 'CookieFont',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(
                  alpha: 0.56,
                ),
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
                fontFamily: 'CookieFont',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(
                  alpha: 0.88,
                ),
              ),
        ),
      ],
    );
  }
}

class _StarMomentLayoutDelegate
    extends SingleChildLayoutDelegate {
  const _StarMomentLayoutDelegate({
    required this.anchor,
    required this.safePadding,
  });

  static const double _screenMargin = 16;
  static const double _starSpacing = 16;

  final Offset anchor;
  final EdgeInsets safePadding;

  @override
  BoxConstraints getConstraintsForChild(
    BoxConstraints constraints,
  ) {
    final availableWidth =
        constraints.maxWidth -
        safePadding.left -
        safePadding.right -
        (_screenMargin * 2);

    final maximumWidth = availableWidth < 320
        ? availableWidth
        : 320.0;

    return BoxConstraints(
      minWidth: maximumWidth,
      maxWidth: maximumWidth,
      maxHeight:
          constraints.maxHeight -
          safePadding.top -
          safePadding.bottom -
          (_screenMargin * 2),
    );
  }

  @override
  Offset getPositionForChild(
    Size size,
    Size childSize,
  ) {
    final minimumLeft =
        safePadding.left + _screenMargin;

    final maximumLeft =
        size.width -
        safePadding.right -
        _screenMargin -
        childSize.width;

    final proposedLeft =
        anchor.dx - childSize.width / 2;

    final left = proposedLeft.clamp(
      minimumLeft,
      maximumLeft,
    ).toDouble();

    final minimumTop =
        safePadding.top + _screenMargin;

    final maximumTop =
        size.height -
        safePadding.bottom -
        _screenMargin -
        childSize.height;

    var proposedTop =
        anchor.dy -
        childSize.height -
        _starSpacing;

    /*
     * Caso não exista espaço acima da estrela,
     * o modal será colocado logo abaixo dela.
     */
    if (proposedTop < minimumTop) {
      proposedTop =
          anchor.dy + _starSpacing;
    }

    final top = proposedTop.clamp(
      minimumTop,
      maximumTop,
    ).toDouble();

    return Offset(left, top);
  }

  @override
  bool shouldRelayout(
    covariant _StarMomentLayoutDelegate
        oldDelegate,
  ) {
    return oldDelegate.anchor != anchor ||
        oldDelegate.safePadding != safePadding;
  }
}