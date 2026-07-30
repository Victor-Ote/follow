import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/babel_book_coordinates.dart';
import 'book_revelation_screen.dart';

class BookCoordinatesScreen extends StatefulWidget {
  const BookCoordinatesScreen({this.onFinished, super.key});

  final VoidCallback? onFinished;

  @override
  State<BookCoordinatesScreen> createState() => _BookCoordinatesScreenState();
}

class _BookCoordinatesScreenState extends State<BookCoordinatesScreen>
    with WidgetsBindingObserver {
  static const Duration _initialBlackPause = Duration(milliseconds: 700);

  static const Duration _fadeDuration = Duration(milliseconds: 1800);

  bool _contentVisible = false;
  String? _hexagon;
  Object? _loadingError;
  bool _hexagonCopied = false;
  bool _isOpeningLibrary = false;
  bool _isWaitingForLibraryReturn = false;
  bool _turnPageButtonVisible = false;
  bool _isOpeningRevelation = false;
  bool _revelationSequenceHasPlayed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareScreen();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final returnedFromLibrary =
        state == AppLifecycleState.resumed && _isWaitingForLibraryReturn;

    if (!returnedFromLibrary || _turnPageButtonVisible || !mounted) {
      return;
    }

    setState(() {
      _isWaitingForLibraryReturn = false;
      _turnPageButtonVisible = true;
    });
  }

  Future<void> _prepareScreen() async {
    try {
      final hexagon = await rootBundle.loadString(
        babelBookCoordinates.hexagonAssetPath,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _hexagon = hexagon.trim();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingError = error;
      });
    }

    await Future<void>.delayed(_initialBlackPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _contentVisible = true;
    });
  }

  Future<void> _copyHexagon() async {
    final hexagon = _hexagon;

    if (hexagon == null || hexagon.isEmpty || _hexagonCopied) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: hexagon));

    if (!mounted) {
      return;
    }

    setState(() {
      _hexagonCopied = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _hexagonCopied = false;
    });
  }

  Future<void> _openLibrary() async {
    if (_isOpeningLibrary) {
      return;
    }

    final libraryUrl = babelBookCoordinates.libraryUrl.trim();

    final libraryUri = Uri.tryParse(libraryUrl);

    final isValidWebAddress =
        libraryUri != null &&
        (libraryUri.scheme == 'https' || libraryUri.scheme == 'http');

    if (!isValidWebAddress) {
      debugPrint(
        'URL inválida da Biblioteca de Babel: '
        '$libraryUrl',
      );

      return;
    }

    setState(() {
      _isOpeningLibrary = true;
      _isWaitingForLibraryReturn = true;
    });

    try {
      final wasOpened = await launchUrl(
        libraryUri,
        mode: LaunchMode.externalApplication,
      );

      if (!wasOpened) {
        if (mounted) {
          setState(() {
            _isWaitingForLibraryReturn = false;
          });
        }

        debugPrint('Não foi possível abrir a Biblioteca de Babel.');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isWaitingForLibraryReturn = false;
        });
      }

      debugPrint('Erro ao abrir a Biblioteca de Babel: $error');
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOpeningLibrary = false;
      });
    }
  }

  Future<void> _openBookRevelation() async {
    if (_isOpeningRevelation) {
      return;
    }

    final shouldAnimateSequence = !_revelationSequenceHasPlayed;

    setState(() {
      _isOpeningRevelation = true;
      _contentVisible = false;
    });

    _revelationSequenceHasPlayed = true;

    await Future<void>.delayed(_fadeDuration);

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (routeContext, animation, secondaryAnimation) {
          return BookRevelationScreen(
            animateSequence: shouldAnimateSequence,
            onConsultAgain: () {
              Navigator.of(routeContext).pop();
            },
            onNextChapter: () {
              widget.onFinished?.call();
            },
          );
        },
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isOpeningRevelation = false;
      _contentVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final horizontalPadding = (screenSize.width * 0.07).clamp(22.0, 42.0);

    final titleFontSize = (screenSize.width * 0.075).clamp(28.0, 34.0);

    final subtitleFontSize = (screenSize.width * 0.048).clamp(17.0, 21.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedOpacity(
          opacity: _contentVisible ? 1 : 0,
          duration: _fadeDuration,
          curve: Curves.easeInOut,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              32,
              horizontalPadding,
              22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Livro encontrado',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Localização',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.6,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HexagonField(
                          value: _hexagon,
                          loadingError: _loadingError,
                          isCopied: _hexagonCopied,
                          onCopy:
                              _hexagon != null &&
                                  _hexagon!.isNotEmpty &&
                                  _loadingError == null
                              ? _copyHexagon
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _CoordinateField(
                          label: 'Wall',
                          value: babelBookCoordinates.wall,
                        ),
                        const SizedBox(height: 17),
                        _CoordinateField(
                          label: 'Shelf',
                          value: babelBookCoordinates.shelf,
                        ),
                        const SizedBox(height: 17),
                        _CoordinateField(
                          label: 'Volume',
                          value: babelBookCoordinates.volume,
                        ),
                        const SizedBox(height: 17),
                        _CoordinateField(
                          label: 'Page',
                          value: babelBookCoordinates.page,
                        ),
                        const SizedBox(height: 34),
                        Text(
                          'Essas coordenadas apontam para um livro\n'
                          'que realmente existe dentro da '
                          'Biblioteca de Babel.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 21,
                                fontFamily: 'CookieFont',
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                                color: Colors.white.withValues(alpha: 0.78),
                              ),
                        ),
                        const SizedBox(height: 38),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _isOpeningLibrary ? null : _openLibrary,
                    child: const Text(
                      'Verificar',
                      style: TextStyle(
                        fontFamily: 'CookieFont',
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                ClipRect(
                  child: AnimatedContainer(
                    height: _turnPageButtonVisible ? 64 : 0,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: _turnPageButtonVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeInOut,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _isOpeningRevelation
                                ? null
                                : _openBookRevelation,
                            child: const Text(
                              'Virar a página',
                              style: TextStyle(
                                fontFamily: 'CookieFont',
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
      ),
    );
  }
}

class _HexagonField extends StatelessWidget {
  const _HexagonField({
    required this.value,
    required this.loadingError,
    required this.isCopied,
    required this.onCopy,
  });

  final String? value;
  final Object? loadingError;
  final bool isCopied;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final displayedValue = switch ((value, loadingError)) {
      (final String hexagon, _) => hexagon,
      (_, final Object _) => 'Não foi possível carregar o Hexagon.',
      _ => 'Carregando...',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(label: 'Hexagon'),
        const SizedBox(height: 8),
        Container(
          height: 125,
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 10, 15),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SelectableText(
                      displayedValue,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.5,
                        height: 1.5,
                        letterSpacing: 0.15,
                        color: Colors.white.withValues(
                          alpha: loadingError == null ? 0.76 : 0.48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 14),
                color: Colors.white.withValues(alpha: 0.10),
              ),
              SizedBox(
                width: 54,
                child: IconButton(
                  onPressed: onCopy,
                  tooltip: isCopied ? 'Hexagon copiado' : 'Copiar Hexagon',
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isCopied
                        ? const Icon(
                            Icons.check_rounded,
                            key: ValueKey('copied'),
                            size: 22,
                          )
                        : const Icon(
                            Icons.content_copy_rounded,
                            key: ValueKey('copy'),
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoordinateField extends StatelessWidget {
  const _CoordinateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label: label),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontFamily: 'CookieFont',
              fontSize: 24,
              fontWeight: FontWeight.w400,
              height: 1.15,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontFamily: 'CookieFont',
        fontSize: 19,
        fontWeight: FontWeight.w400,
        height: 1.1,
        letterSpacing: 0,
        color: Colors.white.withValues(alpha: 0.72),
      ),
    );
  }
}
