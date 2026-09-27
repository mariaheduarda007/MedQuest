import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.infoTexts = const [],
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final List<String> infoTexts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: context.colors.onPrimary,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleMedium
                      ?.withColor(context.colors.onPrimary)
                      .medium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          ...infoTexts.map(
            (text) => Text(
              text,
              style: context.textStyles.labelMedium
                  ?.withColor(context.colors.onPrimary)
                  .light,
            ),
          ),

          const Spacer(),

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver mais',
                    style: context.textStyles.labelMedium
                        ?.bold
                        .withColor(context.colors.secondary),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 25,
                    color: context.colors.outline,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}