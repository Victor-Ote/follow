import 'package:flutter/material.dart';
import '../../data/closing_assets.dart';
import '../../data/closing_metadata.dart';
import '../../widgets/chapter_index_dialog.dart';

import '../../../act_two/presentation/screens/babel_intro_screen.dart';
import '../../../act_four/presentation/screens/first_record_screen.dart';
import '../../../act_five/presentation/screens/universe_intro_screen.dart';


class ClosingFinalScreen extends StatefulWidget {
  const ClosingFinalScreen({super.key});

  @override
  State<ClosingFinalScreen> createState() => _ClosingFinalScreenState();
}

class _ClosingFinalScreenState extends State<ClosingFinalScreen> {
  static const Duration _initialBlackPause = Duration(milliseconds: 900);

  static const Duration _messageFadeDuration = Duration(milliseconds: 1400);

  static const Duration _photoDelay = Duration(milliseconds: 900);

  static const Duration _photoFadeDuration = Duration(milliseconds: 1600);

  static const Duration _signatureDelay = Duration(milliseconds: 850);

  static const Duration _signatureFadeDuration = Duration(milliseconds: 1500);

  static const Duration _metadataDelay = Duration(milliseconds: 650);

  static const Duration _metadataFadeDuration = Duration(milliseconds: 1200);

  static const Duration _chapterLinkDelay = Duration(milliseconds: 900);

  static const Duration _chapterLinkFadeDuration = Duration(milliseconds: 1100);

  static const Duration _indexDialogFadeDuration = Duration(milliseconds: 650);

  static const Duration _chapterScreenFadeDuration = Duration(
    milliseconds: 1300,
  );

  double _messageOpacity = 0;
  double _photoOpacity = 0;
  double _signatureOpacity = 0;
  double _metadataOpacity = 0;
  double _chapterLinkOpacity = 0;

  double _screenOpacity = 1;

  bool _isOpeningChapter = false;

  bool _sequenceStarted = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _sequenceStarted) {
        return;
      }

      _sequenceStarted = true;
      _showClosingMessage();
    });
  }

  Future<void> _showClosingMessage() async {
    /*
     * A tela permanece totalmente preta
     * por um breve momento antes da frase.
     */
    await Future<void>.delayed(_initialBlackPause);

    if (!mounted) {
      return;
    }

    setState(() {
      _messageOpacity = 1;
    });

    /*
 * Esperamos o fade-in da mensagem terminar
 * e mantemos uma pequena pausa antes da foto.
 */
    await Future<void>.delayed(_messageFadeDuration + _photoDelay);

    if (!mounted) {
      return;
    }

    setState(() {
      _photoOpacity = 1;
    });
    setState(() {
      _photoOpacity = 1;
    });

    /*
 * Esperamos o fade-in da foto terminar
 * antes de apresentar a assinatura.
 */
    await Future<void>.delayed(_photoFadeDuration + _signatureDelay);

    if (!mounted) {
      return;
    }

    setState(() {
      _signatureOpacity = 1;
    });

    /*
 * Depois que a assinatura termina de surgir,
 * apresentamos a linha, a data e o horário.
 */
    await Future<void>.delayed(_signatureFadeDuration + _metadataDelay);

    if (!mounted) {
      return;
    }

    setState(() {
      _metadataOpacity = 1;
    });

    /*
 * Depois da linha, data e horário,
 * revelamos discretamente o link do índice.
 */
    await Future<void>.delayed(_metadataFadeDuration + _chapterLinkDelay);

    if (!mounted) {
      return;
    }

    setState(() {
      _chapterLinkOpacity = 1;
    });
  }

  Widget _screenForChapter(_ClosingChapterDestination destination) {
    switch (destination) {
      case _ClosingChapterDestination.book:
        return BabelIntroScreen(
          onFinished: () {
            /*
       * Este callback deve ser exatamente o mesmo
       * utilizado no main.dart para:
       *
       * DevelopmentStartScreen.babelIntro
       */
          },
        );

      case _ClosingChapterDestination.records:
        return const FirstRecordScreen();

      case _ClosingChapterDestination.universe:
        return const UniverseIntroScreen();
    }
  }

  Future<void> _openChapter(_ClosingChapterDestination destination) async {
    if (_isOpeningChapter || !mounted) {
      return;
    }

    setState(() {
      _isOpeningChapter = true;
    });

    /*
   * Fecha primeiro o modal Índice.
   */
    Navigator.of(context, rootNavigator: true).pop();

    /*
   * Aguarda o fade-out do modal terminar.
   */
    await Future<void>.delayed(_indexDialogFadeDuration);

    if (!mounted) {
      return;
    }

    /*
   * Depois, desaparece toda a tela
   * de encerramento.
   */
    setState(() {
      _screenOpacity = 0;
    });

    await Future<void>.delayed(_chapterScreenFadeDuration);

    if (!mounted) {
      return;
    }

    /*
   * Substitui o encerramento pelo capítulo.
   * Não reinicia o aplicativo.
   */
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return _screenForChapter(destination);
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _handleReopenChapterTap() async {
    if (!mounted) {
      return;
    }

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Índice',
      barrierColor: Colors.black.withValues(alpha: 0.82),
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return ChapterIndexDialog(
          onBookPressed: () {
            _openChapter(_ClosingChapterDestination.book);
          },
          onRecordsPressed: () {
            _openChapter(_ClosingChapterDestination.records);
          },
          onUniversePressed: () {
            _openChapter(_ClosingChapterDestination.universe);
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        );

        return FadeTransition(opacity: curvedAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final messageFontSize = screenWidth < 380 ? 34.0 : 39.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _screenOpacity,
        duration: _chapterScreenFadeDuration,
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: _isOpeningChapter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
              child: Stack(
                children: [
                  /*
     * Mensagem posicionada na parte superior,
     * deixando o centro livre para a foto.
     */
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: AnimatedOpacity(
                        opacity: _messageOpacity,
                        duration: _messageFadeDuration,
                        curve: Curves.easeInOut,
                        child: Text(
                          'Obrigado por me encontrar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'CookieFont',
                            fontSize: messageFontSize,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            color: Colors.white.withValues(alpha: 0.94),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /*
     * Foto centralizada independentemente
     * da posição da mensagem.
     */
                  Center(
                    child: AnimatedOpacity(
                      opacity: _photoOpacity,
                      duration: _photoFadeDuration,
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        width: (screenWidth * 0.74)
                            .clamp(240.0, 360.0)
                            .toDouble(),
                        height: (MediaQuery.sizeOf(context).height * 0.44)
                            .clamp(280.0, 440.0)
                            .toDouble(),
                        child: Image.asset(
                          ClosingAssets.photo,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          semanticLabel: 'Nossa foto',
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint(
                              'Não foi possível carregar '
                              '${ClosingAssets.photo}: $error',
                            );

                            /*
               * Caso o arquivo ainda não exista,
               * preservamos o fundo preto.
               */
                            return const SizedBox.expand();
                          },
                        ),
                      ),
                    ),
                  ),
                  /*
 * Assinatura posicionada abaixo da foto.
 *
 * O alinhamento relativo mantém espaço
 * disponível para a linha e a data que
 * serão adicionadas nas próximas etapas.
 */
                  Align(
                    alignment: const Alignment(0, 0.88),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          opacity: _signatureOpacity,
                          duration: _signatureFadeDuration,
                          curve: Curves.easeInOut,
                          child: SizedBox(
                            width: (screenWidth * 0.42)
                                .clamp(140.0, 200.0)
                                .toDouble(),
                            height: 72,
                            child: Image.asset(
                              ClosingAssets.signature,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              semanticLabel: 'Assinatura',
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                  'Não foi possível carregar '
                                  '${ClosingAssets.signature}: '
                                  '$error',
                                );

                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedOpacity(
                          opacity: _metadataOpacity,
                          duration: _metadataFadeDuration,
                          curve: Curves.easeInOut,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                // width: 132,
                                // height: 1,
                                // color: Colors.white.withValues(alpha: 0.18),
                              ),
                              const SizedBox(height: 11),
                              Text(
                                closingMetadata.formattedValue,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'CookieFont',
                                  fontSize: screenWidth < 380 ? 16 : 18,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.35,
                                  color: Colors.white.withValues(alpha: 0.62),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*
 * Link discreto no rodapé.
 *
 * O modal será conectado na próxima etapa.
 */
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IgnorePointer(
                      ignoring: _chapterLinkOpacity == 0,
                      child: AnimatedOpacity(
                        opacity: _chapterLinkOpacity,
                        duration: _chapterLinkFadeDuration,
                        curve: Curves.easeInOut,
                        child: TextButton(
                          onPressed: _handleReopenChapterTap,
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            foregroundColor: Colors.white.withValues(
                              alpha: 0.48,
                            ),
                            overlayColor: Colors.white.withValues(alpha: 0.055),
                          ),
                          child: Text(
                            'Reabrir um capítulo',
                            style: TextStyle(
                              fontFamily: 'CookieFont',
                              fontSize: screenWidth < 380 ? 16 : 17,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white.withValues(
                                alpha: 0.22,
                              ),
                              decorationThickness: 0.7,
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
      ),
    );
  }
}

enum _ClosingChapterDestination { book, records, universe }
