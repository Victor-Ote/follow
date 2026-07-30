import 'package:flutter/material.dart';

import '../../data/universe_stars_data.dart';

import '../../../act_six/presentation/screens/closing_intro_screen.dart';

enum _UniverseFinalContentType { phrase, number, starsLabel, closing }

class UniverseFinalScreen extends StatefulWidget {
  const UniverseFinalScreen({super.key});

  @override
  State<UniverseFinalScreen> createState() => _UniverseFinalScreenState();
}

class _UniverseFinalScreenState extends State<UniverseFinalScreen> {
  static const Duration _fadeDuration = Duration(milliseconds: 1100);

  String _content = '';

  _UniverseFinalContentType _contentType = _UniverseFinalContentType.phrase;

  double _contentOpacity = 0;

  bool _sequenceStarted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _sequenceStarted) {
        return;
      }

      _sequenceStarted = true;
      _runFinalSequence();
    });
  }

  Future<void> _runFinalSequence() async {
    /*
     * Pequena pausa preta depois que o universo
     * termina seu fade-out.
     */
    await _wait(const Duration(milliseconds: 900));

    await _showContent(
      text: 'Durante todo este tempo...',
      type: _UniverseFinalContentType.phrase,
      visibleDuration: const Duration(milliseconds: 1700),
      blackDuration: const Duration(milliseconds: 500),
    );

    await _showContent(
      text: 'Você esteve iluminando\nmeu universo.',
      type: _UniverseFinalContentType.phrase,
      visibleDuration: const Duration(milliseconds: 2100),
      blackDuration: const Duration(milliseconds: 600),
    );

    await _showContent(
      text: 'Sem perceber.',
      type: _UniverseFinalContentType.phrase,
      visibleDuration: const Duration(milliseconds: 1700),
      blackDuration: const Duration(milliseconds: 1700),
    );

    /*
     * O número é calculado diretamente a partir
     * da quantidade atual de estrelas cadastradas.
     */
    await _showContent(
      text: '$universeStarCount',
      type: _UniverseFinalContentType.number,
      visibleDuration: const Duration(milliseconds: 2100),
      blackDuration: const Duration(milliseconds: 450),
    );

    await _showContent(
      text: 'estrelas.',
      type: _UniverseFinalContentType.starsLabel,
      visibleDuration: const Duration(milliseconds: 1800),
      blackDuration: const Duration(milliseconds: 1100),
    );

    await _showContent(
      text:
          'Cada uma delas...\n\n'
          'começou com\n\n'
          '“Eu te amo.”',
      type: _UniverseFinalContentType.closing,
      visibleDuration: const Duration(milliseconds: 4300),
      blackDuration: const Duration(milliseconds: 0),
    );

    if (!mounted) {
      return;
    }

    /*
 * O último conteúdo já terminou seu fade-out.
 * A próxima tela começa também sobre preto.
 */
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const ClosingIntroScreen();
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _showContent({
    required String text,
    required _UniverseFinalContentType type,
    required Duration visibleDuration,
    required Duration blackDuration,
  }) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _content = text;
      _contentType = type;
      _contentOpacity = 0;
    });

    /*
     * Garante que o novo conteúdo seja montado
     * inicialmente com opacidade zero.
     */
    await _wait(const Duration(milliseconds: 80));

    if (!mounted) {
      return;
    }

    setState(() {
      _contentOpacity = 1;
    });

    await _wait(_fadeDuration + visibleDuration);

    if (!mounted) {
      return;
    }

    setState(() {
      _contentOpacity = 0;
    });

    await _wait(_fadeDuration + blackDuration);
  }

  Future<void> _wait(Duration duration) {
    return Future<void>.delayed(duration);
  }

  TextStyle _textStyleForContent(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final responsiveTitleSize = (screenWidth * 0.065).clamp(24.0, 30.0);

    switch (_contentType) {
      case _UniverseFinalContentType.number:
        return const TextStyle(
          fontFamily: 'CookieFont',
          fontSize: 120,
          fontWeight: FontWeight.w400,
          height: 1,
          letterSpacing: 1,
          color: Colors.white,
        );

      case _UniverseFinalContentType.starsLabel:
        return TextStyle(
          fontFamily: 'CookieFont',
          fontSize: screenWidth < 380 ? 38 : 43,
          fontWeight: FontWeight.w400,
          height: 1.1,
          color: Colors.white.withValues(alpha: 0.94),
        );

      case _UniverseFinalContentType.closing:
        return TextStyle(
          fontFamily: 'CookieFont',
          fontSize: responsiveTitleSize,
          fontWeight: FontWeight.w400,
          height: 1.42,
          color: Colors.white.withValues(alpha: 0.94),
        );

      case _UniverseFinalContentType.phrase:
        return TextStyle(
          fontFamily: 'CookieFont',
          fontSize: responsiveTitleSize,
          fontWeight: FontWeight.w400,
          height: 1.35,
          color: Colors.white.withValues(alpha: 0.92),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNumber = _contentType == _UniverseFinalContentType.number;

    Widget content = Text(
      _content,
      textAlign: TextAlign.center,
      style: _textStyleForContent(context),
    );

    /*
     * O FittedBox impede que números muito grandes
     * ultrapassem a largura disponível.
     */
    if (isNumber) {
      content = FittedBox(fit: BoxFit.scaleDown, child: content);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: IgnorePointer(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: AnimatedOpacity(
                  opacity: _contentOpacity,
                  duration: _fadeDuration,
                  curve: Curves.easeInOut,
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
