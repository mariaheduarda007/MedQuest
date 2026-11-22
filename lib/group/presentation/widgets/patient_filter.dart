import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

enum PatientFilterType { all, active, inactive }

class PatientFilter extends StatelessWidget {
  const PatientFilter({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final PatientFilterType selectedFilter;
  final ValueChanged<PatientFilterType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilter(context, label: 'Todos', filter: PatientFilterType.all),
          const SizedBox(width: 8),
          _buildFilter(
            context,
            label: 'Ativos',
            filter: PatientFilterType.active,
          ),
          const SizedBox(width: 8),
          _buildFilter(
            context,
            label: 'Inativos',
            filter: PatientFilterType.inactive,
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(
    BuildContext context, {
    required String label,
    required PatientFilterType filter,
  }) {
    final isSelected = selectedFilter == filter;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onChanged(filter),
      selectedColor: context.colors.secondary,
      backgroundColor: isSelected
          ? context.colors.secondary
          : context.colors.primary,
      labelStyle: TextStyle(
        color: isSelected ? context.colors.primary : context.colors.secondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? context.colors.primary : context.colors.secondary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      showCheckmark: false,
    );
  }
}
