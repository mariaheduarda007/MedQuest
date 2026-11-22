import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class HeaderRoute extends StatelessWidget implements PreferredSizeWidget {
  const HeaderRoute({super.key, required this.route, this.action, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final List<String> route;
  final Widget? action;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      color: colors.secondary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed:
                      onBack ?? () => Navigator.maybePop(context), // DANDO ERRO
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: colors.primary,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < route.length; i++) ...[
                          Text(
                            route[i],
                            style: context.textStyles.labelSmall?.regular
                                .withColor(colors.outline),
                          ),
                          if (i < route.length - 1)
                            Icon(
                              Icons.chevron_right,
                              size: 22,
                              color: colors.outline,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                ?action,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
