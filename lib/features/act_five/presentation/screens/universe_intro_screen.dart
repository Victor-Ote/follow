import 'package:flutter/material.dart';

import 'universe_screen.dart';

class UniverseIntroScreen extends StatefulWidget {
  const UniverseIntroScreen({
    this.onFinished,
    super.key,
  });

  final VoidCallback? onFinished;

  @override
  State<UniverseIntroScreen> createState() =>
      _UniverseIntroScreenState();
}

class _UniverseIntroScreenState
    extends State<UniverseIntroScreen> {
  static const Duration _fadeDuration =
      Duration(milliseconds: 850);

  static const List<_UniverseIntroPhrase>
      _phrases = [
    _UniverseIntroPhrase(
      text: 'O universo guarda...',
      visibleDuration:
          Duration(milliseconds: 1450),
      blackDuration:
          Duration(milliseconds: 350),
      fontSize: 35,
    ),
    _UniverseIntroPhrase(
      text: 'mais do que livros.',
      visibleDuration:
          Duration(milliseconds: 1450),
      blackDuration:
          Duration(milliseconds: 350),
      fontSize: 36,
    ),
    _UniverseIntroPhrase(
      text: 'Mais do que registros.',
      visibleDuration:
          Duration(milliseconds: 1550),
      blackDuration:
          Duration(milliseconds: 450),
      fontSize: 36,
    ),
    _UniverseIntroPhrase(
      text: 'Ele também guarda...',
      visibleDuration:
          Duration(milliseconds: 1450),
      blackDuration:
          Duration(milliseconds: 350),
      fontSize: 35,
    ),
    _UniverseIntroPhrase(
      text: 'pequenas luzes.',
      visibleDuration:
          Duration(milliseconds: 1700),
      blackDuration:
          Duration(milliseconds: 600),
      fontSize: 42,
    ),
    _UniverseIntroPhrase(
      text: 'Cada uma delas...',
      visibleDuration:
          Duration(milliseconds: 1450),
      blackDuration:
          Duration(milliseconds: 350),
      fontSize: 35,
    ),
    _UniverseIntroPhrase(
      text: 'representa um momento.',
      visibleDuration:
          Duration(milliseconds: 1650),
      blackDuration:
          Duration(milliseconds: 600),
      fontSize: 37,
    ),
    _UniverseIntroPhrase(
      text: 'Algumas...',
      visibleDuration:
          Duration(milliseconds: 1250),
      blackDuration:
          Duration(milliseconds: 350),
      fontSize: 35,
    ),
    _UniverseIntroPhrase(
      text: 'brilham mais do que outras.',
      visibleDuration:
          Duration(milliseconds: 1800),
      blackDuration:
          Duration(milliseconds: 750),
      fontSize: 37,
    ),
    _UniverseIntroPhrase(
      text: 'Vamos encontrá-las.',
      visibleDuration:
          Duration(milliseconds: 2000),
      blackDuration:
          Duration(milliseconds: 900),
      fontSize: 41,
    ),
  ];

  String _currentText = '';

  double _contentOpacity = 0;

  bool _sequenceStarted = false;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted || _sequenceStarted) {
        return;
      }

      _sequenceStarted = true;
      _runSequence();
    });
  }

  Future<void> _runSequence() async {
    /*
     * Pequena pausa inicial para que a tela
     * comece completamente preta.
     */
    await _wait(
      const Duration(milliseconds: 800),
    );

    for (final phrase in _phrases) {
      if (!mounted) {
        return;
      }

      await _showPhrase(phrase);
    }

    await _finishIntro();
  }

  Future<void> _showPhrase(
    _UniverseIntroPhrase phrase,
  ) async {
    if (!mounted) {
      return;
    }

    /*
     * Primeiro trocamos o conteúdo enquanto
     * ele ainda está completamente invisível.
     */
    setState(() {
      _currentText = phrase.text;
      _contentOpacity = 0;
    });

    await _wait(
      const Duration(milliseconds: 80),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _contentOpacity = 1;
    });

    /*
     * Fade-in seguido pelo tempo em que
     * a frase permanece totalmente visível.
     */
    await _wait(
      _fadeDuration +
          phrase.visibleDuration,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _contentOpacity = 0;
    });

    /*
     * Fade-out e pausa preta antes da
     * próxima frase.
     */
    await _wait(
      _fadeDuration +
          phrase.blackDuration,
    );
  }

  Future<void> _finishIntro() async {
    if (_isFinishing || !mounted) {
      return;
    }

    _isFinishing = true;

    /*
     * A última frase já terminou seu fade-out.
     * Portanto, a transição acontece sobre preto.
     */
    if (widget.onFinished != null) {
      widget.onFinished!.call();
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const UniverseScreen();
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration:
            Duration.zero,
      ),
    );
  }

  Future<void> _wait(
    Duration duration,
  ) {
    return Future<void>.delayed(duration);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final responsiveTitleSize =
        (screenWidth * 0.065).clamp(24.0, 30.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: IgnorePointer(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 34,
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 620,
                ),
                child: AnimatedOpacity(
                  opacity: _contentOpacity,
                  duration: _fadeDuration,
                  curve: Curves.easeInOut,
                  child: Text(
                    _currentText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CookieFont',
                      fontSize: responsiveTitleSize,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                      color: Colors.white
                          .withValues(
                        alpha: 0.93,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UniverseIntroPhrase {
  const _UniverseIntroPhrase({
    required this.text,
    required this.visibleDuration,
    required this.blackDuration,
    required this.fontSize,
  });

  final String text;
  final Duration visibleDuration;
  final Duration blackDuration;
  final double fontSize;
}