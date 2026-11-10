import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 30, color: context.colors.tertiary),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.titleSmall?.withColor(
                      context.colors.tertiary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: context.textStyles.labelSmall?.withColor(
                      context.colors.outline,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              'Detalhes',
              style: context.textStyles.labelMedium?.bold.withColor(
                context.colors.inversePrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: context.colors.tertiary),
          ],
        ),
      ),
    );
  }
}
