import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

enum ActionButtonVariant { filled, outlined }

enum ActionButtonSize { xs, sm, md, lg, xl }

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ActionButtonVariant variant;
  final ActionButtonSize size;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ActionButtonVariant.filled,
    this.size = ActionButtonSize.md,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == ActionButtonVariant.filled;

    final buttonSize = switch (size) {
      ActionButtonSize.xs => AppButtonSize.xs,
      ActionButtonSize.sm => AppButtonSize.sm,
      ActionButtonSize.md => AppButtonSize.md,
      ActionButtonSize.lg => AppButtonSize.lg,
      ActionButtonSize.xl => AppButtonSize.xl,
    };
    final textStyle = switch (size) {
      ActionButtonSize.xs => context.textStyles.bodyMedium,
      ActionButtonSize.sm => context.textStyles.labelMedium,
      ActionButtonSize.md => context.textStyles.labelLarge,
      ActionButtonSize.lg => context.textStyles.labelLarge,
      ActionButtonSize.xl => context.textStyles.titleMedium,
    };
    final foregroundColor = isFilled
        ? context.colors.primary
        : context.colors.onPrimary;
    final buttonContent = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
            ),
          )
        : Text(
            text,
            maxLines: 1,
            style: textStyle?.copyWith(color: foregroundColor),
          );

    return Container(
      width: buttonSize.width,
      height: buttonSize.height,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: isFilled
          ? FilledButton(
              onPressed: isLoading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.onPrimary,
                foregroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: AppSpacing.paddingXs,
              ),
              child: buttonContent,
            )
          : OutlinedButton(
              onPressed: isLoading ? null : onPressed,

              style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.onPrimary,
                backgroundColor: context.colors.primary,
                side: BorderSide(color: context.colors.onPrimary, width: 2.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
              child: buttonContent,
            ),
    );

    // return Container(
    //       width: 350,
    //       height: 50,
    //       margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    //       child: ElevatedButton(
    //         onPressed: onPressed,
    //         style: ElevatedButton.styleFrom(
    //           elevation: 0,
    //           backgroundColor: isDark
    //               ? context.colors.onPrimary
    //               : context.colors.primary,
    //           foregroundColor: isDark
    //               ? context.colors.primary
    //               : context.colors.onPrimary,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(6),
    //             side: BorderSide(
    //               color: context.colors.onPrimary,
    //               width: isDark ? 0 : 1.5,
    //             ),
    //           ),
    //         ),
    //         child: Text(
    //           text,
    //           style: context.textStyles.titleMedium?.medium.withColor(isDark
    //               ? context.colors.primary
    //               : context.colors.onPrimary),
    //         ),
    //       ),
    //     );
  }
}
