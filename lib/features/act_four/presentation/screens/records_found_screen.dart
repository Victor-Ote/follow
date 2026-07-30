import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../act_five/presentation/screens/universe_intro_screen.dart';

import '../../data/babelia_records_data.dart';
import '../widgets/babelia_reference_field.dart';

class RecordsFoundScreen extends StatefulWidget {
  const RecordsFoundScreen({this.onFinished, super.key});

  final VoidCallback? onFinished;

  @override
  State<RecordsFoundScreen> createState() => _RecordsFoundScreenState();
}

class _RecordsFoundScreenState extends State<RecordsFoundScreen> {
  static const Duration _initialBlackPause = Duration(milliseconds: 650);

  static const Duration _screenFadeDuration = Duration(milliseconds: 1800);

  static const Duration _recordsStartDelay = Duration(milliseconds: 900);

  static const Duration _recordRevealInterval = Duration(milliseconds: 340);

  static const Duration _recordFadeDuration = Duration(milliseconds: 620);

  bool _contentVisible = false;

  bool _recordsSequenceStarted = false;
  int _visibleRecordCount = 0;

  bool _recordsSequenceCompleted = false;
  bool _isLeaving = false;

  List<String?> _recordValues = const [];
  Set<int> _loadingErrorIndexes = const {};
  final Set<int> _copiedRecordIndexes = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareScreen();
    });
  }

  Future<void> _prepareScreen() async {
    final records = babeliaRecordsData.discoveredRecords;

    final loadedValues = <String?>[];
    final loadingErrorIndexes = <int>{};

    for (var index = 0; index < records.length; index++) {
      final assetPath = records[index].valueAssetPath;

      try {
        if (assetPath == null || assetPath.isEmpty) {
          throw StateError('O registro não possui um asset.');
        }

        final value = await rootBundle.loadString(assetPath);

        loadedValues.add(value.trim());
      } catch (error) {
        debugPrint(
          'Erro ao carregar o registro '
          '${records[index].title}: $error',
        );

        loadedValues.add(null);
        loadingErrorIndexes.add(index);
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _recordValues = loadedValues;
      _loadingErrorIndexes = loadingErrorIndexes;
    });

    await Future<void>.delayed(_initialBlackPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _contentVisible = true;
    });

    await _startRecordsSequence();
  }

  Future<void> _finishAct() async {
    if (_isLeaving || !_recordsSequenceCompleted) {
      return;
    }

    setState(() {
      _isLeaving = true;
      _contentVisible = false;
    });

    await Future<void>.delayed(_screenFadeDuration);

    if (!mounted) {
      return;
    }

    if (!mounted) {
      return;
    }

    /*
 * Um callback externo continua tendo prioridade.
 */
    if (widget.onFinished != null) {
      widget.onFinished!.call();
      return;
    }

    /*
 * Sem callback externo, o fluxo normal continua
 * para a introdução do ATO V.
 */
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const UniverseIntroScreen();
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _startRecordsSequence() async {
    if (_recordsSequenceStarted) {
      return;
    }

    _recordsSequenceStarted = true;

    await Future<void>.delayed(_recordsStartDelay);

    if (!mounted) {
      return;
    }

    final totalRecords = babeliaRecordsData.discoveredRecords.length;

    for (var index = 0; index < totalRecords; index++) {
      setState(() {
        _visibleRecordCount = index + 1;
      });

      if (index < totalRecords - 1) {
        await Future<void>.delayed(_recordRevealInterval);

        if (!mounted) {
          return;
        }
      }
    }

    await Future<void>.delayed(_recordFadeDuration);

    if (!mounted) {
      return;
    }

    setState(() {
      _recordsSequenceCompleted = true;
    });
  }

  Future<void> _copyRecordValue(int index) async {
    if (index < 0 ||
        index >= _recordValues.length ||
        _copiedRecordIndexes.contains(index)) {
      return;
    }

    final recordValue = _recordValues[index];

    if (recordValue == null || recordValue.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: recordValue));

    if (!mounted) {
      return;
    }

    setState(() {
      _copiedRecordIndexes.add(index);
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _copiedRecordIndexes.remove(index);
    });
  }

  String _displayedValueFor(int index) {
    if (_loadingErrorIndexes.contains(index)) {
      return 'Não foi possível carregar '
          'este registro.';
    }

    if (index >= _recordValues.length) {
      return 'Carregando...';
    }

    return _recordValues[index] ?? 'Carregando...';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final horizontalPadding = (screenSize.width * 0.07).clamp(24.0, 44.0);

    final titleFontSize = (screenSize.width * 0.075).clamp(28.0, 34.0);

    final messageFontSize = (screenSize.width * 0.057).clamp(21.0, 26.0);

    final records = babeliaRecordsData.discoveredRecords;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedOpacity(
          opacity: _contentVisible ? 1 : 0,
          duration: _screenFadeDuration,
          curve: Curves.easeInOut,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              36,
              horizontalPadding,
              34,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'O universo é infinito.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Colors.white.withValues(alpha: 0.94),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Esses são apenas alguns\n'
                  'dos registros que encontramos.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: messageFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: Colors.white.withValues(alpha: 0.76),
                  ),
                ),
                const SizedBox(height: 32),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                    mainAxisExtent: 120,
                  ),
                  itemBuilder: (context, index) {
                    final recordValueAvailable =
                        index < _recordValues.length &&
                        _recordValues[index] != null &&
                        _recordValues[index]!.isNotEmpty &&
                        !_loadingErrorIndexes.contains(index);

                    final isVisible = index < _visibleRecordCount;

                    return AnimatedOpacity(
                      opacity: isVisible ? 1 : 0,
                      duration: _recordFadeDuration,
                      curve: Curves.easeInOut,
                      child: IgnorePointer(
                        ignoring: !isVisible,
                        child: BabeliaReferenceField(
                          title: records[index].title,
                          value: _displayedValueFor(index),
                          compact: true,
                          isCopied: _copiedRecordIndexes.contains(index),
                          onCopy: recordValueAvailable && !_isLeaving
                              ? () {
                                  _copyRecordValue(index);
                                }
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                IgnorePointer(
                  ignoring: !_recordsSequenceCompleted || _isLeaving,
                  child: AnimatedOpacity(
                    opacity: _recordsSequenceCompleted ? 1 : 0,
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isLeaving ? null : _finishAct,
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
