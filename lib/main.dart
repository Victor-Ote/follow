import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

import 'package:flutter/foundation.dart';
import 'core/config/development_start_screen.dart';
import 'features/act_five/presentation/screens/universe_final_screen.dart';

import 'features/act_one/presentation/screens/mystery_intro_screen.dart';
import 'features/act_one/presentation/screens/identity_screen.dart';
import 'features/act_two/presentation/screens/act_transition_screen.dart';
import 'features/act_two/presentation/screens/babel_intro_screen.dart';
import 'features/act_two/presentation/screens/babel_library_screen.dart';
import 'features/act_three/presentation/screens/book_coordinates_screen.dart';
import 'features/act_three/presentation/screens/book_revelation_screen.dart';
import 'features/act_four/presentation/screens/records_intro_screen.dart';
import 'features/act_four/presentation/screens/first_record_screen.dart';
import 'features/act_four/presentation/screens/records_found_screen.dart';
import 'features/act_five/presentation/screens/universe_screen.dart';
import 'features/act_five/presentation/screens/universe_intro_screen.dart';
import 'features/act_six/presentation/screens/closing_intro_screen.dart';
import 'features/act_six/presentation/screens/closing_final_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AnniversaryExperienceApp());
}

class AnniversaryExperienceApp extends StatelessWidget {
  const AnniversaryExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nossa História',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) {
        if (!kDebugMode ||
            developmentStartScreen == DevelopmentStartScreen.normalExperience) {
          return child ?? const SizedBox.shrink();
        }

        return Navigator(
          onGenerateRoute: (_) {
            return MaterialPageRoute<void>(
              builder: (context) {
                switch (developmentStartScreen) {
                  case DevelopmentStartScreen.recordsFound:
                    return const RecordsFoundScreen();

                  case DevelopmentStartScreen.universeIntro:
                    return const UniverseIntroScreen();

                  case DevelopmentStartScreen.universeCanvas:
                    return const UniverseScreen();

                  case DevelopmentStartScreen.universeFinal:
                    return const UniverseFinalScreen();

                  case DevelopmentStartScreen.actTwoTransition:
                    return ActTransitionScreen(onFinished: () {});

                  case DevelopmentStartScreen.babelIntro:
                    return BabelIntroScreen(onFinished: () {});

                  case DevelopmentStartScreen.babelLibrary:
                    return BabelLibraryScreen(onFinished: () {});

                  case DevelopmentStartScreen.closingIntro:
                    return const ClosingIntroScreen();

                  case DevelopmentStartScreen.closingFinal:
                    return const ClosingFinalScreen();

                  case DevelopmentStartScreen.bookCoordinates:
                    return BookCoordinatesScreen(
                      onFinished: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder<void>(
                            transitionDuration: const Duration(
                              milliseconds: 1400,
                            ),
                            reverseTransitionDuration: const Duration(
                              milliseconds: 1400,
                            ),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return RecordsIntroScreen(
                                onFinished: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder<void>(
                                      transitionDuration: const Duration(
                                        milliseconds: 1800,
                                      ),
                                      reverseTransitionDuration: const Duration(
                                        milliseconds: 1800,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) {
                                            return FirstRecordScreen(
                                              onReturnedFromRecord: () {
                                                Navigator.of(
                                                  context,
                                                ).pushReplacement(
                                                  PageRouteBuilder<void>(
                                                    transitionDuration:
                                                        Duration.zero,
                                                    reverseTransitionDuration:
                                                        Duration.zero,
                                                    pageBuilder:
                                                        (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                        ) {
                                                          return const RecordsFoundScreen();
                                                        },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeInOut,
                                              ),
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                              );
                            },
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                    );

                  case DevelopmentStartScreen.bookRevelation:
                    return BookRevelationScreen(
                      animateSequence: true,
                      onConsultAgain: () {},
                      onNextChapter: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder<void>(
                            transitionDuration: const Duration(
                              milliseconds: 1400,
                            ),
                            reverseTransitionDuration: const Duration(
                              milliseconds: 1400,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                                  return RecordsIntroScreen(
                                    onFinished: () {
                                      Navigator.of(context).pushReplacement(
                                        PageRouteBuilder<void>(
                                          transitionDuration: const Duration(
                                            milliseconds: 1800,
                                          ),
                                          reverseTransitionDuration:
                                              const Duration(
                                                milliseconds: 1800,
                                              ),
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) {
                                                return const FirstRecordScreen();
                                              },
                                          transitionsBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                              ) {
                                                return FadeTransition(
                                                  opacity: CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeInOut,
                                                  ),
                                                  child: child,
                                                );
                                              },
                                        ),
                                      );
                                    },
                                  );
                                },
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                    );
                  case DevelopmentStartScreen.firstRecord:
                    return FirstRecordScreen(
                      onReturnedFromRecord: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder<void>(
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                                  return const RecordsFoundScreen();
                                },
                          ),
                        );
                      },
                    );
                  case DevelopmentStartScreen.normalExperience:
                    return child ?? const SizedBox.shrink();
                }
              },
            );
          },
        );
      },
      home: Builder(
        builder: (context) {
          return MysteryIntroScreen(
            onFinished: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder<void>(
                  transitionDuration: const Duration(milliseconds: 1800),
                  reverseTransitionDuration: const Duration(milliseconds: 1800),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return IdentityScreen(
                      onFinished: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder<void>(
                            transitionDuration: const Duration(
                              milliseconds: 1200,
                            ),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return ActTransitionScreen(
                                onFinished: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder<void>(
                                      transitionDuration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      reverseTransitionDuration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return BabelIntroScreen(
                                          onFinished: () {
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              PageRouteBuilder<void>(
                                                transitionDuration:
                                                    const Duration(
                                                      milliseconds: 1800,
                                                    ),
                                                reverseTransitionDuration:
                                                    const Duration(
                                                      milliseconds: 1800,
                                                    ),
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) {
                                                      return BabelLibraryScreen(
                                                        onFinished: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pushReplacement(
                                                            PageRouteBuilder<
                                                              void
                                                            >(
                                                              transitionDuration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        1800,
                                                                  ),
                                                              reverseTransitionDuration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        1800,
                                                                  ),
                                                              pageBuilder:
                                                                  (
                                                                    context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                  ) {
                                                                    return BookCoordinatesScreen(
                                                                      onFinished: () {
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pushReplacement(
                                                                          PageRouteBuilder<
                                                                            void
                                                                          >(
                                                                            transitionDuration: const Duration(
                                                                              milliseconds: 1400,
                                                                            ),
                                                                            reverseTransitionDuration: const Duration(
                                                                              milliseconds: 1400,
                                                                            ),
                                                                            pageBuilder:
                                                                                (
                                                                                  context,
                                                                                  animation,
                                                                                  secondaryAnimation,
                                                                                ) {
                                                                                  return RecordsIntroScreen(
                                                                                    onFinished: () {
                                                                                      Navigator.of(
                                                                                        context,
                                                                                      ).pushReplacement(
                                                                                        PageRouteBuilder<
                                                                                          void
                                                                                        >(
                                                                                          transitionDuration: const Duration(
                                                                                            milliseconds: 1800,
                                                                                          ),
                                                                                          reverseTransitionDuration: const Duration(
                                                                                            milliseconds: 1800,
                                                                                          ),
                                                                                          pageBuilder:
                                                                                              (
                                                                                                context,
                                                                                                animation,
                                                                                                secondaryAnimation,
                                                                                              ) {
                                                                                                return const FirstRecordScreen();
                                                                                              },
                                                                                          transitionsBuilder:
                                                                                              (
                                                                                                context,
                                                                                                animation,
                                                                                                secondaryAnimation,
                                                                                                child,
                                                                                              ) {
                                                                                                return FadeTransition(
                                                                                                  opacity: CurvedAnimation(
                                                                                                    parent: animation,
                                                                                                    curve: Curves.easeInOut,
                                                                                                  ),
                                                                                                  child: child,
                                                                                                );
                                                                                              },
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                            transitionsBuilder:
                                                                                (
                                                                                  context,
                                                                                  animation,
                                                                                  secondaryAnimation,
                                                                                  child,
                                                                                ) {
                                                                                  return FadeTransition(
                                                                                    opacity: CurvedAnimation(
                                                                                      parent: animation,
                                                                                      curve: Curves.easeInOut,
                                                                                    ),
                                                                                    child: child,
                                                                                  );
                                                                                },
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                              transitionsBuilder:
                                                                  (
                                                                    context,
                                                                    animation,
                                                                    secondaryAnimation,
                                                                    child,
                                                                  ) {
                                                                    return FadeTransition(
                                                                      opacity: CurvedAnimation(
                                                                        parent:
                                                                            animation,
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                      ),
                                                                      child:
                                                                          child,
                                                                    );
                                                                  },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                transitionsBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) {
                                                      return FadeTransition(
                                                        opacity:
                                                            CurvedAnimation(
                                                              parent: animation,
                                                              curve: Curves
                                                                  .easeInOut,
                                                            ),
                                                        child: child,
                                                      );
                                                    },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeInOut,
                                              ),
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                              );
                            },
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                    );
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                          child: child,
                        );
                      },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
