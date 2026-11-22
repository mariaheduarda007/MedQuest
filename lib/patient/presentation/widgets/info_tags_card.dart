import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';

class InfoTagsCard extends StatefulWidget {
  const InfoTagsCard({
    super.key,
    required this.title,
    required this.values,
    this.initiallyExpanded = true,
  });

  final String title;
  final List<String> values;
  final bool initiallyExpanded;

  @override
  State<InfoTagsCard> createState() => _InfoTagsCardState();
}

class _InfoTagsCardState extends State<InfoTagsCard> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e controle de expansão
          InkWell(
            onTap: toggleExpanded,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.medical_information_outlined),
                  SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: context.textStyles.headlineSmall?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colors.secondary,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo expansível
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12),

                      boxShadow: [
                        BoxShadow(
                          color: colors.outline.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.values.map((value) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: colors.secondary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            value,
                            style: context.textStyles.labelMedium?.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
