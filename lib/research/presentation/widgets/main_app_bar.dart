import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
