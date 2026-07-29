import 'package:flutter/material.dart';

class RecordsIntroScreen extends StatefulWidget {
  const RecordsIntroScreen({
    required this.onFinished,
    super.key,
  });

  final VoidCallback onFinished;

  @override
  State<RecordsIntroScreen> createState() =>
      _RecordsIntroScreenState();
}

class _RecordsIntroScreenState
    extends State<RecordsIntroScreen> {
  static const List<String> _messages = [
    'Existe outra possibilidade.',
    'Se todas as palavras possíveis...',
    'Podem existir.',
    'Talvez...',
    'Todos os instantes possíveis...',
    'Também possam existir.',
    'Cada imagem.',
    'Cada momento.',
    'Cada lembrança.',
    'Em algum lugar.',
    'Apenas esperando...',
    'Ser encontrada.',
  ];

  static const Duration _initialBlackPause =
      Duration(milliseconds: 900);

  static const Duration _fadeDuration =
      Duration(milliseconds: 1800);

  static const Duration _visibleDuration =
      Duration(milliseconds: 1700);

  static const Duration _pauseBetweenMessages =
      Duration(milliseconds: 850);

  static const Duration _finalBlackPause =
      Duration(milliseconds: 1400);

  String _currentMessage = '';
  bool _messageVisible = false;
  bool _sequenceStarted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSequence();
    });
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

    for (final message in _messages) {
      await _showMessage(message);

      if (!mounted) {
        return;
      }
    }

    await Future<void>.delayed(_finalBlackPause);

    if (!mounted) {
      return;
    }

    widget.onFinished();
  }

  Future<void> _showMessage(String message) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _currentMessage = message;
      _messageVisible = true;
    });

    await Future<void>.delayed(
      _fadeDuration + _visibleDuration,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _messageVisible = false;
    });

    await Future<void>.delayed(
      _fadeDuration + _pauseBetweenMessages,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final responsiveFontSize = (
      screenWidth * 0.065
    ).clamp(24.0, 30.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
            ),
            child: AnimatedOpacity(
              opacity: _messageVisible ? 1 : 0,
              duration: _fadeDuration,
              curve: Curves.easeInOut,
              child: Text(
                _currentMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontFamily: 'CookieFont',
                      fontSize: responsiveFontSize,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                      color: Colors.white.withValues(
                        alpha: 0.92,
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