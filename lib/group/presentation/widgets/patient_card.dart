import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class PatientCard extends StatelessWidget {
  final String name;
  final int age;
  final bool activity;
  final VoidCallback onTap;

  const PatientCard({
    super.key,
    required this.name,
    required this.age,
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = activity
        ? const Color(0xFFD2E6CE)
        : const Color(0xFFE5BDBA);

    final statusTextColor = activity
        ? const Color(0xFF398B48)
        : const Color(0xFFAD2929);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 390,
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF3),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 21,
              backgroundColor: Color(0xFF351036),
              child: Icon(Icons.person, color: Colors.white, size: 26),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.textStyles.labelMedium?.regular.withColor(
                      context.colors.secondary,
                    ),
                  ),
                  Text(
                    '$age anos',
                    style: context.textStyles.labelSmall?.regular.withColor(
                      context.colors.outline,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                activity ? 'ativo' : 'inativo',
                style: TextStyle(fontSize: 14, color: statusTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
