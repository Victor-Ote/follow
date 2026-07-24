import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/act_one/presentation/screens/mystery_intro_screen.dart';
import 'features/act_one/presentation/screens/identity_screen.dart';
import 'features/act_two/presentation/screens/act_transition_screen.dart';
import 'features/act_two/presentation/screens/babel_intro_screen.dart';
import 'features/act_two/presentation/screens/babel_library_screen.dart';

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
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) {
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
                                                              /*
                                                              * O ATO II termina aqui.
                                                              *
                                                              * A abertura do ATO III será
                                                              * conectada futuramente.
                                                              *
                                                              * Por enquanto, a tela permanece preta.
                                                              */
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
                                                                  parent:
                                                                      animation,
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
