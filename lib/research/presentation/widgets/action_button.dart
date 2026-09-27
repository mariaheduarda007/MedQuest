import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDark;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 50,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isDark
              ? context.colors.onPrimary
              : context.colors.primary,
          foregroundColor: isDark
              ? context.colors.primary
              : context.colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: context.colors.onPrimary,
              width: isDark ? 0 : 1.5,
            ),
          ),
        ),
        child: Text(
          text,
          style: context.textStyles.titleMedium?.medium.withColor(isDark
              ? context.colors.primary
              : context.colors.onPrimary),
        ),
      ),
    );
  }
}