import 'package:flutter/material.dart';

class ChapterIndexDialog extends StatelessWidget {
  const ChapterIndexDialog({
    this.onBookPressed,
    this.onRecordsPressed,
    this.onUniversePressed,
    super.key,
  });

  /*
   * Os callbacks já ficam preparados para a
   * etapa posterior de navegação.
   *
   * Nesta etapa, permanecerão nulos.
   */
  final VoidCallback? onBookPressed;
  final VoidCallback? onRecordsPressed;
  final VoidCallback? onUniversePressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final titleFontSize =
        screenWidth < 380 ? 31.0 : 34.0;

    return Dialog(
      backgroundColor: const Color(0xFF090909),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 40,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: Colors.white.withValues(
            alpha: 0.14,
          ),
          width: 1,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 360,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            26,
            28,
            26,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Índice',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CookieFont',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: Colors.white.withValues(
                    alpha: 0.95,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 92,
                height: 1,
                color: Colors.white.withValues(
                  alpha: 0.13,
                ),
              ),
              const SizedBox(height: 22),
              _ChapterIndexEntry(
                chapter: 'Capítulo II',
                title: 'O Livro',
                onTap: onBookPressed,
              ),
              const SizedBox(height: 9),
              _ChapterIndexEntry(
                chapter: 'Capítulo IV',
                title: 'Os Registros',
                onTap: onRecordsPressed,
              ),
              const SizedBox(height: 9),
              _ChapterIndexEntry(
                chapter: 'Capítulo V',
                title: 'O Universo',
                onTap: onUniversePressed,
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white.withValues(
                  alpha: 0.08,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop();
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  foregroundColor:
                      Colors.white.withValues(
                    alpha: 0.62,
                  ),
                  overlayColor:
                      Colors.white.withValues(
                    alpha: 0.055,
                  ),
                ),
                child: const Text(
                  'Fechar',
                  style: TextStyle(
                    fontFamily: 'CookieFont',
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterIndexEntry
    extends StatelessWidget {
  const _ChapterIndexEntry({
    required this.chapter,
    required this.title,
    required this.onTap,
  });

  final String chapter;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        overlayColor:
            WidgetStatePropertyAll(
          Colors.white.withValues(
            alpha: 0.045,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                chapter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CookieFont',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  color: Colors.white.withValues(
                    alpha: 0.48,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CookieFont',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  height: 1.15,
                  color: Colors.white.withValues(
                    alpha: 0.90,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}