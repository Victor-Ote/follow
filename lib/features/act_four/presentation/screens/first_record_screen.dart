import 'package:flutter/material.dart';

import '../../data/babelia_records_data.dart';
import '../widgets/babelia_reference_field.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'records_found_screen.dart';

class FirstRecordScreen extends StatefulWidget {
  const FirstRecordScreen({this.onReturnedFromRecord, super.key});

  final VoidCallback? onReturnedFromRecord;

  @override
  State<FirstRecordScreen> createState() => _FirstRecordScreenState();
}

class _FirstRecordScreenState extends State<FirstRecordScreen>
    with WidgetsBindingObserver {
  static const Duration _initialBlackPause = Duration(milliseconds: 700);

  static const Duration _fadeDuration = Duration(milliseconds: 1800);

  bool _contentVisible = false;
  String? _recordValue;
  Object? _loadingError;
  bool _recordCopied = false;
  bool _isOpeningRecord = false;

  bool _isWaitingForRecordReturn = false;
  bool _didLeaveAppForRecord = false;
  bool _recordReturnHandled = false;

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

    if (!_isWaitingForRecordReturn || _recordReturnHandled) {
      return;
    }

    final appLeftForeground =
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden;

    if (appLeftForeground) {
      _didLeaveAppForRecord = true;
      return;
    }

    final returnedFromRecord =
        state == AppLifecycleState.resumed && _didLeaveAppForRecord;

    if (returnedFromRecord) {
      _handleRecordReturn();
    }
  }

  Future<void> _handleRecordReturn() async {
    if (_recordReturnHandled || !mounted) {
      return;
    }

    _recordReturnHandled = true;
    _isWaitingForRecordReturn = false;

    setState(() {
      _contentVisible = false;
    });

    await Future<void>.delayed(_fadeDuration);

    if (!mounted) {
      return;
    }

    if (widget.onReturnedFromRecord != null) {
      widget.onReturnedFromRecord!.call();
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const RecordsFoundScreen();
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _prepareScreen() async {
    final assetPath = babeliaRecordsData.firstRecord.valueAssetPath;

    try {
      if (assetPath == null || assetPath.isEmpty) {
        throw StateError('O primeiro registro não possui um asset.');
      }

      final recordValue = await rootBundle.loadString(assetPath);

      if (!mounted) {
        return;
      }

      setState(() {
        _recordValue = recordValue.trim();
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

  Future<void> _copyRecordValue() async {
    final recordValue = _recordValue;

    if (recordValue == null || recordValue.isEmpty || _recordCopied) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: recordValue));

    if (!mounted) {
      return;
    }

    setState(() {
      _recordCopied = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _recordCopied = false;
    });
  }

  Future<void> _openFirstRecord() async {
    if (_isOpeningRecord || _recordReturnHandled) {
      return;
    }

    final recordUrl = babeliaRecordsData.firstRecordUrl.trim();

    final recordUri = Uri.tryParse(recordUrl);

    final isValidWebAddress =
        recordUri != null &&
        (recordUri.scheme == 'https' || recordUri.scheme == 'http');

    if (!isValidWebAddress) {
      debugPrint(
        'URL inválida do primeiro registro: '
        '$recordUrl',
      );

      return;
    }

    setState(() {
      _isOpeningRecord = true;
      _isWaitingForRecordReturn = true;
      _didLeaveAppForRecord = false;
    });

    try {
      final wasOpened = await launchUrl(
        recordUri,
        mode: LaunchMode.externalApplication,
      );

      if (!wasOpened) {
        if (mounted) {
          setState(() {
            _isWaitingForRecordReturn = false;
            _didLeaveAppForRecord = false;
          });
        }

        debugPrint('Não foi possível abrir o primeiro registro.');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isWaitingForRecordReturn = false;
          _didLeaveAppForRecord = false;
        });
      }

      debugPrint('Erro ao abrir o primeiro registro: $error');
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOpeningRecord = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final horizontalPadding = (screenSize.width * 0.07).clamp(24.0, 44.0);

    final titleFontSize = (screenSize.width * 0.075).clamp(28.0, 34.0);

    final subtitleFontSize = (screenSize.width * 0.058).clamp(21.0, 26.0);

    final messageFontSize = (screenSize.width * 0.064).clamp(23.0, 29.0);

    final displayedRecordValue = switch ((_recordValue, _loadingError)) {
      (final String value, _) => value,
      (_, final Object _) => 'Não foi possível carregar o registro.',
      _ => 'Carregando...',
    };

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
              36,
              horizontalPadding,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Primeiro registro encontrado',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Colors.white.withValues(alpha: 0.94),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Referência',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 30),
                BabeliaReferenceField(
                  title: babeliaRecordsData.firstRecord.title,
                  value: displayedRecordValue,
                  isCopied: _recordCopied,
                  onCopy:
                      _recordValue != null &&
                          _recordValue!.isNotEmpty &&
                          _loadingError == null
                      ? _copyRecordValue
                      : null,
                ),
                const Spacer(flex: 3),
                Text(
                  'Talvez...\n\n'
                  'este seja apenas o começo.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'CookieFont',
                    fontSize: messageFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: Colors.white.withValues(alpha: 0.86),
                  ),
                ),
                const Spacer(flex: 4),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _isOpeningRecord ? null : _openFirstRecord,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
