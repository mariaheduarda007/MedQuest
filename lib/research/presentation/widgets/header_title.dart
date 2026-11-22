import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.title,
    this.buttonTitle,
    this.onPressed,
  });

  final String title;
  final String? buttonTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.textStyles.titleLarge?.fontSize,
            fontWeight: FontWeight.bold,
            color: context.colors.secondary,
          ),
        ),
        if (buttonTitle != null)
          ActionButton(
            onPressed: onPressed,
            text: buttonTitle!,
            variant: ActionButtonVariant.filled,
            size: ActionButtonSize.sm,
          ),
      ],
    );
  }
}
