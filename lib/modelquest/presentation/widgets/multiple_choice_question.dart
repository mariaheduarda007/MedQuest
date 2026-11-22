import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final String title;
  final List<String> choices;
  final List<num> values;
  final num? selectedValue;
  final ValueChanged<num?>? onChanged;
  final String? orientation;
  final int numeration;
  final bool? enabled;

  const MultipleChoiceQuestion({
    super.key,
    required this.title,
    required this.choices,
    required this.values,
    required this.numeration,
    this.selectedValue,
    this.orientation,
    this.onChanged,
    this.enabled,
  }) : assert(choices.length == values.length);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  num? selectedValue;
  String? orientation;
  late int numeration;
  bool? enabled;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
    orientation = widget.orientation;
    numeration = widget.numeration;
    enabled = widget.enabled;
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedValue != widget.selectedValue) {
      selectedValue = widget.selectedValue;
    }
  }

  void selectAnswer(num value) {
    setState(() {
      selectedValue = value;
    });

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orientation != null
              ? Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                    ),
                  ),

                  child: Text(
                    '$orientation',
                    style: context.textStyles.bodyLarge?.withColor(
                      context.colors.primary,
                    ),
                  ),
                )
              : SizedBox(),
          const SizedBox(height: 10),
          Text(
            '$numeration. ${widget.title}',
            style: context.textStyles.titleSmall?.withColor(
              context.colors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(widget.choices.length, (index) {
            final choice = widget.choices[index];
            final value = widget.values[index];

            final isSelected = selectedValue == value;

            return GestureDetector(
              onTap: () => enabled == true ? null : () => selectAnswer(value),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.outline,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        '$choice ($value)',
                        style: context.textStyles.bodyLarge?.withColor(
                          context.colors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
