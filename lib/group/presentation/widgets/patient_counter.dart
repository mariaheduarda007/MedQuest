import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class PatientCounter extends StatelessWidget {
  const PatientCounter({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.colors.secondary, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$count',
            style: context.textStyles.labelMedium?.copyWith(
              color: context.colors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            count == 1 ? ' Paciente cadastrado' : ' Pacientes cadastrados',
            style: context.textStyles.labelMedium?.regular.withColor(
              context.colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
