import 'package:flutter/material.dart';

import '../../data/universe_star.dart';

class StarMomentOverlay extends StatelessWidget {
  const StarMomentOverlay({
    required this.star,
    required this.anchor,
    required this.modalScale,
    required this.placeBelow,
    required this.onClose,
    super.key,
  });

  final UniverseStar star;

  /// Posição atual da estrela na tela.
  final Offset anchor;

  /// Escala visual do modal.
  ///
  /// Será 1.0 somente quando o universo estiver
  /// no nível máximo de zoom.
  final double modalScale;

  /// Define se o modal ficará abaixo ou acima
  /// da estrela selecionada.
  final bool placeBelow;

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _StarMomentLayoutDelegate(
        anchor: anchor,
        modalScale: modalScale,
        placeBelow: placeBelow,
      ),
      child: Transform.scale(
        scale: modalScale,
        alignment: placeBelow ? Alignment.topCenter : Alignment.bottomCenter,
        filterQuality: FilterQuality.medium,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0B0B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.16),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.88),
                  blurRadius: 22,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.035),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(width: 8),
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
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.09),
                ),
                const SizedBox(height: 15),
                Text(
                  'Mensagem',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.58),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  star.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: Colors.white.withValues(alpha: 0.90),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MomentInformation extends StatelessWidget {
  const _MomentInformation({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontFamily: 'CookieFont',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.56),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontFamily: 'CookieFont',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.88),
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
    required this.modalScale,
    required this.placeBelow,
  });

  static const double _baseWidth = 260;
  static const double _baseStarSpacing = 18;

  final Offset anchor;
  final double modalScale;
  final bool placeBelow;

  @override
  BoxConstraints getConstraintsForChild(
    BoxConstraints constraints,
  ) {
    return BoxConstraints(
      minWidth: _baseWidth,
      maxWidth: _baseWidth,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(
    Size size,
    Size childSize,
  ) {
    final visualSpacing =
        _baseStarSpacing * modalScale;

    /*
     * O centro horizontal do modal permanece
     * exatamente alinhado à estrela.
     */
    final left =
        anchor.dx - childSize.width / 2;

    if (placeBelow) {
      /*
       * Com Alignment.topCenter, o topo visual
       * permanece fixo neste ponto durante a escala.
       */
      return Offset(
        left,
        anchor.dy + visualSpacing,
      );
    }

    /*
     * Com Alignment.bottomCenter, a base visual
     * permanece ancorada acima da estrela.
     */
    return Offset(
      left,
      anchor.dy -
          visualSpacing -
          childSize.height,
    );
  }

  @override
  bool shouldRelayout(
    covariant _StarMomentLayoutDelegate
        oldDelegate,
  ) {
    return oldDelegate.anchor != anchor ||
        oldDelegate.modalScale != modalScale ||
        oldDelegate.placeBelow != placeBelow;
  }
}

//   @override
//   Offset getPositionForChild(Size size, Size childSize) {
//     final visualWidth = childSize.width * scale;

//     final visualHeight = childSize.height * scale;

//     final minimumVisualLeft = safePadding.left + _screenMargin;

//     final maximumVisualLeft =
//         size.width - safePadding.right - _screenMargin - visualWidth;

//     final proposedVisualLeft = anchor.dx - visualWidth / 2;

//     final visualLeft = minimumVisualLeft <= maximumVisualLeft
//         ? proposedVisualLeft
//               .clamp(minimumVisualLeft, maximumVisualLeft)
//               .toDouble()
//         : (size.width - visualWidth) / 2;

//     final minimumVisualTop = safePadding.top + _screenMargin;

//     final maximumVisualTop =
//         size.height - safePadding.bottom - _screenMargin - visualHeight;

//     /*
//      * Primeiro tentamos posicionar acima da estrela.
//      */
//     var visualTop = anchor.dy - _starSpacing - visualHeight;

//     /*
//      * Caso não exista espaço acima, posicionamos abaixo.
//      */
//     if (visualTop < minimumVisualTop) {
//       visualTop = anchor.dy + _starSpacing;
//     }

//     if (minimumVisualTop <= maximumVisualTop) {
//       visualTop = visualTop
//           .clamp(minimumVisualTop, maximumVisualTop)
//           .toDouble();
//     } else {
//       visualTop = minimumVisualTop;
//     }

//     /*
//      * A escala utiliza Alignment.bottomCenter.
//      * Por isso convertemos a posição visual desejada
//      * novamente para a posição do widget antes da escala.
//      */
//     final visualCenterX = visualLeft + visualWidth / 2;

//     final visualBottom = visualTop + visualHeight;

//     final layoutLeft = visualCenterX - childSize.width / 2;

//     final layoutTop = visualBottom - childSize.height;

//     return Offset(layoutLeft, layoutTop);
//   }

//   @override
//   bool shouldRelayout(covariant _StarMomentLayoutDelegate oldDelegate) {
//     return oldDelegate.anchor != anchor ||
//         oldDelegate.safePadding != safePadding ||
//         oldDelegate.scale != scale;
//   }
// }

  // @override
  // Offset getPositionForChild(Size size, Size childSize) {
  //   final minimumLeft = safePadding.left + _screenMargin;

  //   final maximumLeft =
  //       size.width - safePadding.right - _screenMargin - childSize.width;

  //   final centeredLeft = (size.width - childSize.width) / 2;

  //   final left = centeredLeft.clamp(minimumLeft, maximumLeft).toDouble();

  //   final minimumTop = safePadding.top + _screenMargin;

  //   final proposedTop =
  //       size.height - safePadding.bottom - _bottomSpacing - childSize.height;

  //   final top = proposedTop < minimumTop ? minimumTop : proposedTop;

  //   return Offset(left, top);
  // }

  // @override
  // bool shouldRelayout(covariant _StarMomentLayoutDelegate oldDelegate) {
  //   return oldDelegate.safePadding != safePadding;
  // }
// }
