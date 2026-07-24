import 'package:flutter/material.dart';

class MysteryIntroScreen extends StatefulWidget {
  const MysteryIntroScreen({
    required this.onFinished,
    super.key,
  });

  final VoidCallback onFinished;

  @override
  State<MysteryIntroScreen> createState() => _MysteryIntroScreenState();
}

class _MysteryIntroScreenState extends State<MysteryIntroScreen> {
  static const List<String> _messages = [
    'Este aplicativo não possui menu.',
    'Não possui configurações.',
    'Nem foi criado para qualquer pessoa.',
  ];

  static const Duration _initialDelay = Duration(seconds: 2);
  static const Duration _fadeDuration = Duration(milliseconds: 1800);
  static const Duration _visibleDuration = Duration(milliseconds: 1700);
  static const Duration _pauseBetweenMessages = Duration(milliseconds: 900);
  static const Duration _finalPause = Duration(milliseconds: 1200);

  String _currentMessage = '';
  bool _isVisible = false;
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

    await Future<void>.delayed(_initialDelay);

    if (!mounted) {
      return;
    }

    for (final message in _messages) {
      await _showMessage(message);

      if (!mounted) {
        return;
      }
    }

    await Future<void>.delayed(_finalPause);

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
      _isVisible = true;
    });

    await Future<void>.delayed(_fadeDuration + _visibleDuration);

    if (!mounted) {
      return;
    }

    setState(() {
      _isVisible = false;
    });

    await Future<void>.delayed(
      _fadeDuration + _pauseBetweenMessages,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: _fadeDuration,
              curve: Curves.easeInOut,
              child: Text(
                _currentMessage,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}