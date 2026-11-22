import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/research/domain/models/research_entity.dart';

class EditResearchDialog extends StatefulWidget {
  const EditResearchDialog({super.key, required this.research});

  final Research research;

  @override
  State<EditResearchDialog> createState() => _EditResearchDialogState();
}

class _EditResearchDialogState extends State<EditResearchDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final List<TextEditingController> _attributeControllers = [];
  final List<TextEditingController> _retiredControllers = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.research.name);
    for (final attribute in widget.research.researchAttributes.entries) {
      _attributeControllers.add(TextEditingController(text: attribute.key));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in [
      ..._attributeControllers,
      ..._retiredControllers,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAttribute() {
    setState(() {
      _attributeControllers.add(TextEditingController());
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      _retiredControllers.add(_attributeControllers.removeAt(index));
    });
  }

  String? _validateAttribute(int index, String? value) {
    final attribute = value?.trim() ?? '';
    if (attribute.isEmpty) return 'Informe o nome do atributo.';

    for (
      var otherIndex = 0;
      otherIndex < _attributeControllers.length;
      otherIndex++
    ) {
      if (otherIndex != index &&
          _attributeControllers[otherIndex].text.trim() == attribute) {
        return 'Este atributo já foi informado.';
      }
    }
    return null;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final attributes = <String, String>{};
    for (final controller in _attributeControllers) {
      final attribute = controller.text.trim();
      attributes[attribute] = attribute;
    }

    Navigator.of(context).pop(
      widget.research.copyWith(
        name: _nameController.text.trim(),
        researchAttributes: attributes,
      ),
    );
  }

  InputDecoration _decoration(String label, ColorScheme colors) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: colors.primary,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colors.secondary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.primary,
      title: Text(
        'Editar pesquisa',
        style: context.textStyles.titleLarge?.copyWith(color: colors.onSurface),
      ),
      content: SizedBox(
        width: 480,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: _decoration('Nome da pesquisa', colors),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Informe o nome da pesquisa.'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Atributos',
                      style: context.textStyles.titleMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_attributeControllers.isEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nenhum atributo cadastrado.',
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ...List.generate(_attributeControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _attributeControllers[index],
                              decoration: _decoration('Atributo', colors),
                              validator: (value) =>
                                  _validateAttribute(index, value),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remover atributo',
                            onPressed: () => _removeAttribute(index),
                            icon: Icon(
                              Icons.delete_outline,
                              color: colors.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _addAttribute,
                      icon: Icon(Icons.add, color: colors.secondary),
                      label: Text(
                        'Adicionar atributo',
                        style: TextStyle(color: colors.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: colors.secondary),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: colors.onPrimary,
            foregroundColor: colors.primary,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
