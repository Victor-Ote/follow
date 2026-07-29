import 'package:flutter/material.dart';

class BabeliaReferenceField extends StatelessWidget {
  const BabeliaReferenceField({
    required this.title,
    required this.value,
    this.onCopy,
    this.isCopied = false,
    this.compact = false,
    super.key,
  });

  final String title;
  final String value;
  final VoidCallback? onCopy;
  final bool isCopied;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final fieldHeight = compact ? 88.0 : 126.0;
    final titleFontSize = compact ? 19.0 : 24.0;
    final titleSpacing = compact ? 6.0 : 9.0;
    final fieldBorderRadius = compact ? 12.0 : 16.0;
    final copyAreaWidth = compact ? 42.0 : 54.0;
    final valueFontSize = compact ? 10.5 : 12.5;
    final valueLineHeight = compact ? 1.35 : 1.5;
    final copyIconSize = compact ? 18.0 : 20.0;
    final checkIconSize = compact ? 20.0 : 22.0;

    final contentPadding = compact
        ? const EdgeInsets.fromLTRB(10, 9, 6, 9)
        : const EdgeInsets.fromLTRB(16, 14, 10, 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontFamily: 'CookieFont',
              fontSize: titleFontSize,
              fontWeight: FontWeight.w400,
              height: 1.1,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ),
        SizedBox(height: titleSpacing),
        Container(
          height: fieldHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(fieldBorderRadius),
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
                  padding: contentPadding,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SelectableText(
                      value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: valueFontSize,
                        height: valueLineHeight,
                        letterSpacing: compact ? 0.05 : 0.15,
                        color: Colors.white.withValues(alpha: 0.76),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                margin: EdgeInsets.symmetric(vertical: compact ? 10 : 14),
                color: Colors.white.withValues(alpha: 0.10),
              ),
              SizedBox(
                width: copyAreaWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onCopy,
                  tooltip: isCopied ? 'Número copiado' : 'Copiar número',
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isCopied
                        ? Icon(
                            Icons.check_rounded,
                            key: const ValueKey('copied'),
                            size: checkIconSize,
                          )
                        : Icon(
                            Icons.content_copy_rounded,
                            key: const ValueKey('copy'),
                            size: copyIconSize,
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
