import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  final String title;
  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: context.colors.primary,
              ),
            )
          : null,
      title: Text(
        title,
        style: context.textStyles.displayLarge
            ?.withColor(context.colors.primary)
            .regular,
      ),
      centerTitle: true,
    );
  }
}
