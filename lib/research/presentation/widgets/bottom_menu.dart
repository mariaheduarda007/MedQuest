import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/core/theme/theme.dart';

class BottomMenuBar extends StatefulWidget {
  const BottomMenuBar({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  void _navigateTo(String routeName) {
    context.pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: context.colors.outline, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavigationItem(
            icon: Icons.home_rounded,
            label: 'Início',
            selected: widget.initialIndex == 0,
            onTap: () => _navigateTo(MedQuestRouteNames.home),
          ),

          _NavigationItem(
            icon: Icons.science_outlined,
            label: 'Pesquisas',
            selected: widget.initialIndex == 1,
            onTap: () => _navigateTo(MedQuestRouteNames.researches),
          ),

          _NavigationItem(
            icon: Icons.description_outlined,
            label: 'Questionários',
            selected: widget.initialIndex == 2,
            onTap: () => _navigateTo(MedQuestRouteNames.quests),
          ),

          _NavigationItem(
            icon: Icons.account_circle_rounded,
            label: 'Conta',
            selected: widget.initialIndex == 3,
            onTap: () => _navigateTo(MedQuestRouteNames.profile),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? context.colors.secondary : context.colors.outline;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: context.textStyles.labelMedium?.withColor(color),
            ),
          ],
        ),
      ),
    );
  }
}
