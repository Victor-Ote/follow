import 'package:flutter/material.dart';

import '../../../../shared/presentation/widgets/subtle_star_field.dart';

class ActTransitionScreen extends StatefulWidget {
  const ActTransitionScreen({
    required this.onFinished,
    super.key,
  });

  final VoidCallback onFinished;

  @override
  State<ActTransitionScreen> createState() =>
      _ActTransitionScreenState();
}

class _ActTransitionScreenState extends State<ActTransitionScreen> {
  static const Duration _initialBlackPause =
      Duration(milliseconds: 350);

  static const Duration _fadeDuration =
      Duration(milliseconds: 2200);

  static const Duration _starsVisibleDuration =
      Duration(milliseconds: 2400);

  static const Duration _finalBlackPause =
      Duration(milliseconds: 900);

  bool _starsVisible = false;
  bool _sequenceStarted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTransition();
    });
  }

  Future<void> _startTransition() async {
    if (_sequenceStarted) {
      return;
    }

    _sequenceStarted = true;

    await Future<void>.delayed(_initialBlackPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _starsVisible = true;
    });

    await Future<void>.delayed(
      _fadeDuration + _starsVisibleDuration,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _starsVisible = false;
    });

    await Future<void>.delayed(
      _fadeDuration + _finalBlackPause,
    );

    if (!mounted) {
      return;
    }

    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _starsVisible ? 1 : 0,
        duration: _fadeDuration,
        curve: Curves.easeInOut,
        child: const SubtleStarField(),
      ),
    );
  }
}