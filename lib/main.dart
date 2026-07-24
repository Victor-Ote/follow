import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/act_one/presentation/screens/mystery_intro_screen.dart';
import 'features/act_one/presentation/screens/identity_screen.dart';

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
            transitionDuration: const Duration(
              milliseconds: 1800,
            ),
            reverseTransitionDuration: const Duration(
              milliseconds: 1800,
            ),
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) {
              return const IdentityScreen();
            },
            transitionsBuilder: (
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
),
    );
  }

  
}