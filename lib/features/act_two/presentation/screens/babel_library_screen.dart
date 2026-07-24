import 'package:flutter/material.dart';

import '../widgets/minimalist_bookshelf.dart';
import '../../data/correct_book_repository.dart';

class BabelLibraryScreen extends StatefulWidget {
  const BabelLibraryScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<BabelLibraryScreen> createState() => _BabelLibraryScreenState();
}

class _BabelLibraryScreenState extends State<BabelLibraryScreen> {
  static const Duration _initialBlackPause = Duration(milliseconds: 700);

  static const Duration _fadeDuration = Duration(milliseconds: 2200);
  static const Duration _otherBooksFadeDuration = Duration(milliseconds: 1400);

  static const Duration _lightExpansionDuration = Duration(milliseconds: 3200);

  static const Duration _whiteScreenPause = Duration(milliseconds: 700);

  static const Duration _fadeToBlackDuration = Duration(milliseconds: 1800);

  final CorrectBookRepository _correctBookRepository = CorrectBookRepository();

  int? _correctBookIndex;
  Offset? _lightOrigin;

  bool _isRevealingCorrectBook = false;
  bool _lightExpanded = false;
  bool _blackOverlayVisible = false;
  bool _endingStarted = false;

  bool _contentVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareLibrary();
    });
  }

  Future<void> _prepareLibrary() async {
    final correctBookIndex = await _correctBookRepository
        .getOrCreateCorrectBookIndex(
          totalBooks: MinimalistBookshelf.totalBooks,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _correctBookIndex = correctBookIndex;
    });

    await _revealContent();
  }

  Future<void> _revealContent() async {
    await Future<void>.delayed(_initialBlackPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _contentVisible = true;
    });
  }

  Future<void> _handleCorrectBookSelected(Offset globalBookCenter) async {
    if (_endingStarted) {
      return;
    }

    _endingStarted = true;

    setState(() {
      _lightOrigin = globalBookCenter;
      _isRevealingCorrectBook = true;
    });

    await Future<void>.delayed(_otherBooksFadeDuration);

    if (!mounted) {
      return;
    }

    setState(() {
      _lightExpanded = true;
    });

    await Future<void>.delayed(_lightExpansionDuration + _whiteScreenPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _blackOverlayVisible = true;
    });

    await Future<void>.delayed(_fadeToBlackDuration);

    if (!mounted) {
      return;
    }

    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;

    final responsiveFontSize = (screenWidth * 0.061).clamp(23.0, 29.0);

    final lightOrigin =
        _lightOrigin ?? Offset(screenSize.width / 2, screenSize.height / 2);

    final maximumLightSize = screenSize.longestSide * 2.8;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: AnimatedOpacity(
              opacity: _contentVisible ? 1 : 0,
              duration: _fadeDuration,
              curve: Curves.easeInOut,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = (constraints.maxWidth * 0.075)
                      .clamp(24.0, 48.0);

                  final topPadding = (constraints.maxHeight * 0.07).clamp(
                    34.0,
                    68.0,
                  );

                  final bottomPadding = (constraints.maxHeight * 0.035).clamp(
                    18.0,
                    34.0,
                  );

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          opacity: _isRevealingCorrectBook ? 0.20 : 1,
                          duration: _otherBooksFadeDuration,
                          curve: Curves.easeInOut,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Text(
                              'Se todos os livros existem...\n\n'
                              'um deles conta exatamente\n'
                              'a história que você procura.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontFamily: 'CookieFont',
                                    fontSize: responsiveFontSize,
                                    fontWeight: FontWeight.w400,
                                    height: 1.35,
                                    letterSpacing: 0.1,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: (constraints.maxHeight * 0.075).clamp(
                            34.0,
                            64.0,
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 520,
                              maxHeight: 560,
                            ),
                            child: _correctBookIndex == null
                                ? const SizedBox.shrink()
                                : MinimalistBookshelf(
                                    correctBookIndex: _correctBookIndex!,
                                    isRevealingCorrectBook:
                                        _isRevealingCorrectBook,
                                    onCorrectBookSelected:
                                        _handleCorrectBookSelected,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          if (_isRevealingCorrectBook)
            IgnorePointer(
              child: AnimatedPositioned(
                duration: _lightExpansionDuration,
                curve: Curves.easeInOutCubic,
                left: _lightExpanded
                    ? lightOrigin.dx - maximumLightSize / 2
                    : lightOrigin.dx - 12,
                top: _lightExpanded
                    ? lightOrigin.dy - maximumLightSize / 2
                    : lightOrigin.dy - 12,
                width: _lightExpanded ? maximumLightSize : 24,
                height: _lightExpanded ? maximumLightSize : 24,
                child: AnimatedOpacity(
                  opacity: _lightExpanded ? 1 : 0.42,
                  duration: const Duration(milliseconds: 1400),
                  curve: Curves.easeInOut,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.96),
                          Colors.white.withValues(alpha: 0.76),
                          Colors.white.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.34, 0.68, 1],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.28),
                          blurRadius: 34,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _blackOverlayVisible ? 1 : 0,
              duration: _fadeToBlackDuration,
              curve: Curves.easeInOut,
              child: const ColoredBox(
                color: Colors.black,
                child: SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
