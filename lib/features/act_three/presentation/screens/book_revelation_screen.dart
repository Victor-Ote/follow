import 'package:flutter/material.dart';


class BookRevelationScreen extends StatefulWidget {
  const BookRevelationScreen({
    required this.onConsultAgain,
    required this.onNextChapter,
    this.animateSequence = true,
    super.key,
  });

  final VoidCallback onConsultAgain;
  final VoidCallback onNextChapter;

  /// Quando false, as frases e os botões aparecem
  /// imediatamente, sem repetir a sequência.
  final bool animateSequence;

  @override
  State<BookRevelationScreen> createState() =>
      _BookRevelationScreenState();
}

class _BookRevelationScreenState
    extends State<BookRevelationScreen> {
  static const Duration _initialBlackPause =
      Duration(milliseconds: 650);

  static const Duration _phraseInterval =
      Duration(milliseconds: 1000);

  static const Duration _phraseFadeDuration =
      Duration(milliseconds: 1100);

  static const Duration _buttonsFadeDuration =
      Duration(milliseconds: 1000);

  static const Duration _screenFadeOutDuration =
      Duration(milliseconds: 1400);

  bool _firstPhraseVisible = false;
  bool _secondPhraseVisible = false;
  bool _thirdPhraseVisible = false;
  bool _buttonsVisible = false;

  bool _screenVisible = true;
  bool _sequenceStarted = false;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.animateSequence) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startSequence();
      });
    } else {
      _showCompleteContentImmediately();
    }
  }

  void _showCompleteContentImmediately() {
    _firstPhraseVisible = true;
    _secondPhraseVisible = true;
    _thirdPhraseVisible = true;
    _buttonsVisible = true;
  }

  Future<void> _startSequence() async {
    if (_sequenceStarted) {
      return;
    }

    _sequenceStarted = true;

    await Future<void>.delayed(_initialBlackPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _firstPhraseVisible = true;
    });

    await Future<void>.delayed(_phraseInterval);

    if (!mounted) {
      return;
    }

    setState(() {
      _secondPhraseVisible = true;
    });

    await Future<void>.delayed(_phraseInterval);

    if (!mounted) {
      return;
    }

    setState(() {
      _thirdPhraseVisible = true;
    });

    await Future<void>.delayed(_phraseInterval);

    if (!mounted) {
      return;
    }

    setState(() {
      _buttonsVisible = true;
    });
  }

  Future<void> _leaveScreen(
    VoidCallback callback,
  ) async {
    if (_isLeaving) {
      return;
    }

    _isLeaving = true;

    setState(() {
      _screenVisible = false;
    });

    await Future<void>.delayed(
      _screenFadeOutDuration,
    );

    if (!mounted) {
      return;
    }

    callback();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final horizontalPadding = (
      screenSize.width * 0.07
    ).clamp(24.0, 44.0);

    final phraseFontSize = (
      screenSize.width * 0.072
    ).clamp(26.0, 32.0);

    final finalPhraseFontSize = (
      screenSize.width * 0.082
    ).clamp(29.0, 36.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _screenVisible ? 1 : 0,
        duration: _screenFadeOutDuration,
        curve: Curves.easeInOut,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              28,
              horizontalPadding,
              24,
            ),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AnimatedPhrase(
                      text: 'Então...',
                      visible: _firstPhraseVisible,
                      duration: _phraseFadeDuration,
                      fontSize: phraseFontSize,
                    ),
                    const SizedBox(height: 24),
                    _AnimatedPhrase(
                      text: 'Nós realmente...',
                      visible: _secondPhraseVisible,
                      duration: _phraseFadeDuration,
                      fontSize: phraseFontSize,
                    ),
                    const SizedBox(height: 24),
                    _AnimatedPhrase(
                      text: 'SEMPRE existimos.',
                      visible: _thirdPhraseVisible,
                      duration: _phraseFadeDuration,
                      fontSize: finalPhraseFontSize,
                    ),
                  ],
                ),
                const Spacer(flex: 4),
                AnimatedOpacity(
                  opacity: _buttonsVisible ? 1 : 0,
                  duration: _buttonsFadeDuration,
                  curve: Curves.easeInOut,
                  child: IgnorePointer(
                    ignoring: !_buttonsVisible ||
                        _isLeaving,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () {
                                _leaveScreen(
                                  widget.onConsultAgain,
                                );
                              },
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Consultar novamente',
                                  style: TextStyle(
                                    fontFamily:
                                        'CookieFont',
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: FilledButton(
                              onPressed: () {
                                _leaveScreen(
                                  widget.onNextChapter,
                                );
                              },
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Próximo capítulo',
                                  style: TextStyle(
                                    fontFamily:
                                        'CookieFont',
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _AnimatedPhrase extends StatelessWidget {
  const _AnimatedPhrase({
    required this.text,
    required this.visible,
    required this.duration,
    required this.fontSize,
  });

  final String text;
  final bool visible;
  final Duration duration;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: duration,
      curve: Curves.easeInOut,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(
              fontFamily: 'CookieFont',
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              height: 1.2,
              color: Colors.white.withValues(
                alpha: 0.92,
              ),
            ),
      ),
    );
  }
}