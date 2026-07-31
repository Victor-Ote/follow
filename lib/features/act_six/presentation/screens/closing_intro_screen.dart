import 'package:flutter/material.dart';

import 'closing_final_screen.dart';

enum _ClosingContentType { phrase, oneYear }

class ClosingIntroScreen extends StatefulWidget {
  const ClosingIntroScreen({this.onFinished, super.key});

  /// Será utilizado posteriormente para abrir
  /// a Tela 2 do ATO VI.
  final VoidCallback? onFinished;

  @override
  State<ClosingIntroScreen> createState() => _ClosingIntroScreenState();
}

class _ClosingIntroScreenState extends State<ClosingIntroScreen> {
  static const Duration _initialBlackPause = Duration(milliseconds: 900);

  static const Duration _fadeDuration = Duration(milliseconds: 1050);

  static const List<_ClosingPhrase> _openingPhrases = [
    _ClosingPhrase(
      text: 'Você deve estar pensando...',
      visibleDuration: Duration(milliseconds: 1750),
      blackDuration: Duration(milliseconds: 500),
    ),
    _ClosingPhrase(
      text: 'Quanto tempo demorou\npara criar isso?',
      visibleDuration: Duration(milliseconds: 2200),
      blackDuration: Duration(milliseconds: 550),
    ),
    _ClosingPhrase(
      text: 'Algumas semanas?',
      visibleDuration: Duration(milliseconds: 1550),
      blackDuration: Duration(milliseconds: 450),
    ),
    _ClosingPhrase(
      text: 'Alguns meses?',
      visibleDuration: Duration(milliseconds: 1550),
      blackDuration: Duration(milliseconds: 650),
    ),
    _ClosingPhrase(
      text: 'Na verdade...',
      visibleDuration: Duration(milliseconds: 1750),
      blackDuration: Duration(milliseconds: 750),
    ),
  ];

  static const _ClosingPhrase _oneYearPhrase = _ClosingPhrase(
    text: 'Tudo isso\ncomeçou\nhá exatamente\num ano.',
    visibleDuration: Duration(milliseconds: 3900),
    blackDuration: Duration(milliseconds: 1100),
    contentType: _ClosingContentType.oneYear,
  );

  static const List<_ClosingPhrase> _finalPhrases = [
    _ClosingPhrase(
      text: 'Toda vez que você dizia...',
      visibleDuration: Duration(milliseconds: 1850),
      blackDuration: Duration(milliseconds: 550),
    ),
    _ClosingPhrase(
      text: '"Eu te amo"',
      visibleDuration: Duration(milliseconds: 1900),
      blackDuration: Duration(milliseconds: 700),
    ),
    _ClosingPhrase(
      text: 'Eu guardava aquele momento.',
      visibleDuration: Duration(milliseconds: 2100),
      blackDuration: Duration(milliseconds: 600),
    ),
    _ClosingPhrase(
      text: 'Sem você perceber.',
      visibleDuration: Duration(milliseconds: 1750),
      blackDuration: Duration(milliseconds: 600),
    ),
    _ClosingPhrase(
      text: 'Para que hoje...',
      visibleDuration: Duration(milliseconds: 1700),
      blackDuration: Duration(milliseconds: 600),
    ),
    _ClosingPhrase(
      text: 'Você pudesse enxergá-los.',
      visibleDuration: Duration(milliseconds: 2600),
      blackDuration: Duration(milliseconds: 1100),
    ),
  ];

  String _currentText = '';

  _ClosingContentType _contentType = _ClosingContentType.phrase;

  double _contentOpacity = 0;

  bool _sequenceStarted = false;
  bool _sequenceFinished = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _sequenceStarted) {
        return;
      }

      _sequenceStarted = true;
      _runSequence();
    });
  }

  Future<void> _runSequence() async {
    await _wait(_initialBlackPause);

    for (final phrase in _openingPhrases) {
      if (!mounted) {
        return;
      }

      await _showPhrase(phrase);
    }

    if (!mounted) {
      return;
    }

    await _showPhrase(_oneYearPhrase);

    for (final phrase in _finalPhrases) {
      if (!mounted) {
        return;
      }

      await _showPhrase(phrase);
    }

    if (!mounted || _sequenceFinished) {
      return;
    }

    _sequenceFinished = true;

    /*
 * Um callback externo continua tendo
 * prioridade quando for fornecido.
 */
    if (widget.onFinished != null) {
      widget.onFinished!.call();
      return;
    }

    /*
 * No fluxo normal, avançamos diretamente
 * para a Tela 2 do encerramento.
 *
 * A última frase já terminou o fade-out,
 * portanto a troca acontece sobre preto.
 */
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const ClosingFinalScreen();
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _showPhrase(_ClosingPhrase phrase) async {
    if (!mounted) {
      return;
    }

    /*
     * O novo texto é colocado enquanto
     * permanece completamente invisível.
     */
    setState(() {
      _currentText = phrase.text;
      _contentType = phrase.contentType;
      _contentOpacity = 0;
    });

    /*
     * Cria um frame separado entre a troca
     * do texto e o início do fade-in.
     */
    await _wait(const Duration(milliseconds: 90));

    if (!mounted) {
      return;
    }

    setState(() {
      _contentOpacity = 1;
    });

    await _wait(_fadeDuration + phrase.visibleDuration);

    if (!mounted) {
      return;
    }

    setState(() {
      _contentOpacity = 0;
    });

    await _wait(_fadeDuration + phrase.blackDuration);
  }

  Future<void> _wait(Duration duration) {
    return Future<void>.delayed(duration);
  }

  TextStyle _contentStyle(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    switch (_contentType) {
      case _ClosingContentType.oneYear:
        return TextStyle(
          fontFamily: 'CookieFont',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          height: 1.55,
          color: Colors.white.withValues(alpha: 0.95),
        );

      case _ClosingContentType.phrase:
        return TextStyle(
          fontFamily: 'CookieFont',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          height: 1.38,
          color: Colors.white.withValues(alpha: 0.92),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IgnorePointer(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: AnimatedOpacity(
                  opacity: _contentOpacity,
                  duration: _fadeDuration,
                  curve: Curves.easeInOut,
                  child: Text(
                    _currentText,
                    textAlign: TextAlign.center,
                    style: _contentStyle(context),
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

class _ClosingPhrase {
  const _ClosingPhrase({
    required this.text,
    required this.visibleDuration,
    required this.blackDuration,
    this.contentType = _ClosingContentType.phrase,
  });

  final String text;
  final Duration visibleDuration;
  final Duration blackDuration;
  final _ClosingContentType contentType;
}
