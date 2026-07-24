import 'package:flutter/material.dart';

enum IdentityScreenStage { identification, rejected, welcome, finished }

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  /*
   * Substitua posteriormente pelo nome completo correto.
   *
   * A comparação diferencia letras maiúsculas e minúsculas,
   * mas ignora espaços acidentais no início e no final.
   */
  static const Set<String> _expectedNames = {
    'Fernanda Walzl',
    'Fernanda Walzl de Araujo',
    'Fernanda Walzl de Araújo',
  };

  /*
   * Nome exibido durante a sequência de boas-vindas.
   *
   * Pode ser apenas o primeiro nome ou a forma como você
   * normalmente chama sua namorada.
   */
  static const String _displayName = 'Meu amor';

  static const Duration _contentTransitionDuration = Duration(
    milliseconds: 1200,
  );

  static const Duration _welcomeFadeDuration = Duration(milliseconds: 1800);

  static const Duration _welcomeVisibleDuration = Duration(milliseconds: 1700);

  static const Duration _pauseBetweenMessages = Duration(milliseconds: 700);

  static const Duration _initialWelcomePause = Duration(milliseconds: 1800);

  static const Duration _finalPause = Duration(milliseconds: 1800);

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  IdentityScreenStage _stage = IdentityScreenStage.identification;

  String _welcomeMessage = '';
  bool _welcomeMessageVisible = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _validateName() async {
    if (_isProcessing) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final typedName = _nameController.text.trim();

    if (_expectedNames.contains(typedName)) {
      await _startWelcomeSequence();
      return;
    }

    setState(() {
      _stage = IdentityScreenStage.rejected;
    });

    _nameController.clear();
  }

  void _tryAgain() {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _stage = IdentityScreenStage.identification;
    });

    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }

      _nameFocusNode.requestFocus();
    });
  }

  Future<void> _startWelcomeSequence() async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;

    setState(() {
      _stage = IdentityScreenStage.welcome;
    });

    await Future<void>.delayed(_initialWelcomePause);

    if (!mounted) {
      return;
    }

    const messages = ['Olá,', _displayName, 'Eu estava esperando você.'];

    for (final message in messages) {
      await _showWelcomeMessage(message);

      if (!mounted) {
        return;
      }
    }

    await Future<void>.delayed(_finalPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _stage = IdentityScreenStage.finished;
    });

    widget.onFinished();
  }

  Future<void> _showWelcomeMessage(String message) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _welcomeMessage = message;
      _welcomeMessageVisible = true;
    });

    await Future<void>.delayed(_welcomeFadeDuration + _welcomeVisibleDuration);

    if (!mounted) {
      return;
    }

    setState(() {
      _welcomeMessageVisible = false;
    });

    await Future<void>.delayed(_welcomeFadeDuration + _pauseBetweenMessages);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final responsiveTitleSize = (screenWidth * 0.065).clamp(24.0, 30.0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: _contentTransitionDuration,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: _buildFadeTransition,
          child: _buildCurrentStage(responsiveTitleSize: responsiveTitleSize),
        ),
      ),
    );
  }

  Widget _buildFadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    );
  }

  Widget _buildCurrentStage({required double responsiveTitleSize}) {
    switch (_stage) {
      case IdentityScreenStage.identification:
        return _buildIdentificationContent(
          key: const ValueKey('identification'),
          responsiveTitleSize: responsiveTitleSize,
        );

      case IdentityScreenStage.rejected:
        return _buildRejectedContent(
          key: const ValueKey('rejected'),
          responsiveTitleSize: responsiveTitleSize,
        );

      case IdentityScreenStage.welcome:
        return _buildWelcomeContent(
          key: const ValueKey('welcome'),
          responsiveTitleSize: responsiveTitleSize,
        );

      case IdentityScreenStage.finished:
        return const SizedBox.expand(key: ValueKey('finished'));
    }
  }

  Widget _buildIdentificationContent({
    required Key key,
    required double responsiveTitleSize,
  }) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
            child: IntrinsicHeight(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Quem está usando este aplicativo?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'CookieFont',
                          fontSize: responsiveTitleSize,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 48),
                      TextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.name],
                        cursorColor: Colors.white70,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.4,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nome completo',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white38,
                              width: 0.8,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                        onSubmitted: (_) {
                          _validateName();
                        },
                      ),
                      const SizedBox(height: 52),
                      _CinematicButton(
                        label: 'Continuar',
                        onPressed: _validateName,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRejectedContent({
    required Key key,
    required double responsiveTitleSize,
  }) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Este aplicativo não foi criado para você.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'CookieFont',
                  fontSize: responsiveTitleSize,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 52),
              _CinematicButton(label: 'Tentar novamente', onPressed: _tryAgain),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeContent({
    required Key key,
    required double responsiveTitleSize,
  }) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: AnimatedOpacity(
          opacity: _welcomeMessageVisible ? 1 : 0,
          duration: _welcomeFadeDuration,
          curve: Curves.easeInOut,
          child: Text(
            _welcomeMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontFamily: 'CookieFont',
              fontSize: responsiveTitleSize,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _CinematicButton extends StatelessWidget {
  const _CinematicButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: Colors.white38, width: 0.8),
        ),
      ),
      child: Text(label),
    );
  }
}
