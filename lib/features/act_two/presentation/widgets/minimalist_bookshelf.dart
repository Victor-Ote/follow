import 'package:flutter/material.dart';

class MinimalistBookshelf extends StatelessWidget {
  const MinimalistBookshelf({
    required this.correctBookIndex,
    required this.onCorrectBookSelected,
    this.isRevealingCorrectBook = false,
    super.key,
  });

  static const int totalBooks = 35;

  final int correctBookIndex;
  final ValueChanged<Offset> onCorrectBookSelected;
  final bool isRevealingCorrectBook;

  static const int _booksPerShelf = 7;
  static const int _shelfCount = 5;

  static const List<_BookVisualData> _books = [
    // Prateleira 1
    _BookVisualData(
      widthFactor: 0.78,
      heightFactor: 0.84,
      color: Color(0xFFE8E5DF),
    ),
    _BookVisualData(
      widthFactor: 0.95,
      heightFactor: 0.96,
      color: Color(0xFFD2D2D0),
    ),
    _BookVisualData(
      widthFactor: 0.70,
      heightFactor: 0.76,
      color: Color(0xFFF0EEE8),
    ),
    _BookVisualData(
      widthFactor: 0.88,
      heightFactor: 0.90,
      color: Color(0xFFBFC0BF),
    ),
    _BookVisualData(
      widthFactor: 0.73,
      heightFactor: 0.81,
      color: Color(0xFFE0DDD6),
    ),
    _BookVisualData(
      widthFactor: 1.00,
      heightFactor: 0.88,
      color: Color(0xFFD8D7D3),
    ),
    _BookVisualData(
      widthFactor: 0.82,
      heightFactor: 0.72,
      color: Color(0xFFF2F0EA),
    ),

    // Prateleira 2
    _BookVisualData(
      widthFactor: 0.92,
      heightFactor: 0.78,
      color: Color(0xFFCACAC8),
    ),
    _BookVisualData(
      widthFactor: 0.68,
      heightFactor: 0.92,
      color: Color(0xFFEAE7E0),
    ),
    _BookVisualData(
      widthFactor: 0.84,
      heightFactor: 0.86,
      color: Color(0xFFD6D4CF),
    ),
    _BookVisualData(
      widthFactor: 1.00,
      heightFactor: 0.74,
      color: Color(0xFFF0EEE9),
    ),
    _BookVisualData(
      widthFactor: 0.75,
      heightFactor: 0.98,
      color: Color(0xFFC4C5C4),
    ),
    _BookVisualData(
      widthFactor: 0.90,
      heightFactor: 0.82,
      color: Color(0xFFDEDBD5),
    ),
    _BookVisualData(
      widthFactor: 0.72,
      heightFactor: 0.89,
      color: Color(0xFFE7E6E2),
    ),

    // Prateleira 3
    _BookVisualData(
      widthFactor: 0.80,
      heightFactor: 0.95,
      color: Color(0xFFF1EFE9),
    ),
    _BookVisualData(
      widthFactor: 0.98,
      heightFactor: 0.80,
      color: Color(0xFFCFCECA),
    ),
    _BookVisualData(
      widthFactor: 0.66,
      heightFactor: 0.72,
      color: Color(0xFFE4E1DA),
    ),
    _BookVisualData(
      widthFactor: 0.86,
      heightFactor: 0.89,
      color: Color(0xFFBABBB9),
    ),
    _BookVisualData(
      widthFactor: 0.74,
      heightFactor: 0.84,
      color: Color(0xFFEEECE6),
    ),
    _BookVisualData(
      widthFactor: 0.94,
      heightFactor: 0.97,
      color: Color(0xFFD7D5D0),
    ),
    _BookVisualData(
      widthFactor: 0.70,
      heightFactor: 0.77,
      color: Color(0xFFE1DED7),
    ),

    // Prateleira 4
    _BookVisualData(
      widthFactor: 1.00,
      heightFactor: 0.87,
      color: Color(0xFFECEAE4),
    ),
    _BookVisualData(
      widthFactor: 0.76,
      heightFactor: 0.73,
      color: Color(0xFFC8C8C6),
    ),
    _BookVisualData(
      widthFactor: 0.88,
      heightFactor: 0.94,
      color: Color(0xFFE2DFD8),
    ),
    _BookVisualData(
      widthFactor: 0.67,
      heightFactor: 0.82,
      color: Color(0xFFF0EEE8),
    ),
    _BookVisualData(
      widthFactor: 0.96,
      heightFactor: 0.76,
      color: Color(0xFFCECDCA),
    ),
    _BookVisualData(
      widthFactor: 0.79,
      heightFactor: 0.99,
      color: Color(0xFFE5E3DE),
    ),
    _BookVisualData(
      widthFactor: 0.72,
      heightFactor: 0.88,
      color: Color(0xFFBDBEBC),
    ),

    // Prateleira 5
    _BookVisualData(
      widthFactor: 0.86,
      heightFactor: 0.79,
      color: Color(0xFFDDDAD4),
    ),
    _BookVisualData(
      widthFactor: 0.70,
      heightFactor: 0.96,
      color: Color(0xFFF1EFEA),
    ),
    _BookVisualData(
      widthFactor: 0.98,
      heightFactor: 0.84,
      color: Color(0xFFC5C5C3),
    ),
    _BookVisualData(
      widthFactor: 0.74,
      heightFactor: 0.74,
      color: Color(0xFFE8E5DE),
    ),
    _BookVisualData(
      widthFactor: 0.91,
      heightFactor: 0.91,
      color: Color(0xFFD2D0CB),
    ),
    _BookVisualData(
      widthFactor: 0.68,
      heightFactor: 0.86,
      color: Color(0xFFEDEBE5),
    ),
    _BookVisualData(
      widthFactor: 0.82,
      heightFactor: 0.98,
      color: Color(0xFFBFC0BE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bookshelfWidth = constraints.maxWidth;
        final bookshelfHeight = constraints.maxHeight;

        final shelfThickness = (bookshelfHeight * 0.012).clamp(3.0, 6.0);

        final horizontalPadding = (bookshelfWidth * 0.025).clamp(6.0, 12.0);

        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(
                color: const Color(0xFFBEBEBB).withValues(alpha: 0.42),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: List.generate(_shelfCount, (shelfIndex) {
                final firstBookIndex = shelfIndex * _booksPerShelf;

                final shelfBooks = _books.sublist(
                  firstBookIndex,
                  firstBookIndex + _booksPerShelf,
                );

                return Expanded(
                  child: _BookshelfRow(
                    books: shelfBooks,
                    shelfThickness: shelfThickness,
                    firstBookIndex: firstBookIndex,
                    correctBookIndex: correctBookIndex,
                    isRevealingCorrectBook: isRevealingCorrectBook,
                    onCorrectBookSelected: onCorrectBookSelected,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _BookshelfRow extends StatelessWidget {
  const _BookshelfRow({
    required this.books,
    required this.shelfThickness,
    required this.firstBookIndex,
    required this.correctBookIndex,
    required this.isRevealingCorrectBook,
    required this.onCorrectBookSelected,
  });

  final List<_BookVisualData> books;
  final double shelfThickness;
  final int firstBookIndex;
  final int correctBookIndex;
  final bool isRevealingCorrectBook;
  final ValueChanged<Offset> onCorrectBookSelected;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final bookAreaHeight = availableHeight - shelfThickness;

        final spacing = (availableWidth * 0.008).clamp(2.0, 5.0);

        final totalSpacing = spacing * (books.length - 1);

        final availableBookWidth = availableWidth - totalSpacing;

        final baseBookWidth = availableBookWidth / books.length;

        return Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(books.length, (index) {
                  final book = books[index];
                  final globalBookIndex = firstBookIndex + index;

                  final isCorrectBook = globalBookIndex == correctBookIndex;

                  final shouldFade = isRevealingCorrectBook && !isCorrectBook;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == books.length - 1 ? 0 : spacing,
                    ),
                    child: AnimatedOpacity(
                      opacity: shouldFade ? 0.26 : 1,
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeInOut,
                      child: _MinimalistBook(
                        width: baseBookWidth * book.widthFactor,
                        height: bookAreaHeight * book.heightFactor,
                        color: book.color,
                        detailPosition: book.detailPosition,
                        isCorrectBook: isCorrectBook,
                        interactionEnabled: !isRevealingCorrectBook,
                        onCorrectBookSelected: onCorrectBookSelected,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              height: shelfThickness,
              decoration: BoxDecoration(
                color: const Color(0xFFC9C7C1).withValues(alpha: 0.66),
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.07),
                    blurRadius: 8,
                    spreadRadius: 0.2,
                    offset: const Offset(0, -1),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.85),
                    blurRadius: 7,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
class _MinimalistBook extends StatefulWidget {
  const _MinimalistBook({
    required this.width,
    required this.height,
    required this.color,
    required this.detailPosition,
    required this.isCorrectBook,
    required this.interactionEnabled,
    required this.onCorrectBookSelected,
  });

  final double width;
  final double height;
  final Color color;
  final double detailPosition;
  final bool isCorrectBook;
  final bool interactionEnabled;
  final ValueChanged<Offset> onCorrectBookSelected;

  @override
  State<_MinimalistBook> createState() =>
      _MinimalistBookState();
}

class _MinimalistBookState extends State<_MinimalistBook>
    with SingleTickerProviderStateMixin {
  static const Duration _tiltDuration =
      Duration(milliseconds: 280);

  static const Duration _returnDuration =
      Duration(milliseconds: 650);

  static const Duration _correctBookPause =
      Duration(milliseconds: 500);

  static const double _tiltAngle = 0.0523599;

  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  bool _isAnimating = false;
  bool _wasDiscovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _tiltDuration,
      reverseDuration: _returnDuration,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: _tiltAngle,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateBook() async {
    if (_isAnimating ||
        !widget.interactionEnabled ||
        _wasDiscovered) {
      return;
    }

    _isAnimating = true;

    await _controller.forward();

    if (!mounted) {
      return;
    }

    if (widget.isCorrectBook) {
      await Future<void>.delayed(
        _correctBookPause,
      );

      if (!mounted) {
        return;
      }

      _wasDiscovered = true;

      final renderObject = context.findRenderObject();

      if (renderObject is RenderBox &&
          renderObject.hasSize) {
        final globalCenter = renderObject.localToGlobal(
          renderObject.size.center(Offset.zero),
        );

        widget.onCorrectBookSelected(
          globalCenter,
        );
      }

      return;
    }

    await Future<void>.delayed(
      const Duration(milliseconds: 90),
    );

    if (!mounted) {
      return;
    }

    await _controller.reverse();

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = (
      widget.width * 0.08
    ).clamp(1.0, 2.5);

    final detailHeight = (
      widget.height * 0.018
    ).clamp(1.0, 2.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _animateBook,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            alignment: Alignment.bottomCenter,
            child: child,
          );
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.color.withValues(
              alpha: 0.92,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
              width: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(
                  alpha: widget.isCorrectBook &&
                          _wasDiscovered
                      ? 0.30
                      : 0.035,
                ),
                blurRadius: widget.isCorrectBook &&
                        _wasDiscovered
                    ? 18
                    : 6,
                spreadRadius: widget.isCorrectBook &&
                        _wasDiscovered
                    ? 2
                    : 0.1,
              ),
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.65,
                ),
                blurRadius: 4,
                offset: const Offset(1.5, 2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    top: constraints.maxHeight *
                        widget.detailPosition,
                    left: widget.width * 0.16,
                    right: widget.width * 0.16,
                    child: Container(
                      height: detailHeight,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: 0.14,
                        ),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight *
                        (widget.detailPosition + 0.055),
                    left: widget.width * 0.22,
                    right: widget.width * 0.22,
                    child: Container(
                      height: detailHeight,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.13,
                        ),
                        borderRadius:
                            BorderRadius.circular(10),
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
class _BookVisualData {
  const _BookVisualData({
    required this.widthFactor,
    required this.heightFactor,
    required this.color,
    this.detailPosition = 0.22,
  });

  final double widthFactor;
  final double heightFactor;
  final Color color;
  final double detailPosition;
}
