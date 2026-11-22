import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';

class EditPatientDialog extends StatefulWidget {
  const EditPatientDialog({
    super.key,
    required this.patient,
    required this.researchAttributes,
  });

  final Patient patient;
  final Map<String, String> researchAttributes;

  @override
  State<EditPatientDialog> createState() => _EditPatientDialogState();
}

class _EditPatientDialogState extends State<EditPatientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _startAge;
  late final TextEditingController _sex;
  late final TextEditingController _income;
  late final TextEditingController _elitism;
  late final TextEditingController _ethnicity;
  late final TextEditingController _birthPlacement;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _occupation;
  late final TextEditingController _education;
  late final TextEditingController _drugs;
  late final TextEditingController _comorbidities;
  late final TextEditingController _exitReason;
  late DateTime _birthDate;
  late SmokingLevel _smokingLevel;
  late bool _participationStatus;
  final List<TextEditingController> _attributeKeyControllers = [];
  final List<TextEditingController> _attributeValueControllers = [];
  final List<TextEditingController> _retiredControllers = [];

  @override
  void initState() {
    super.initState();
    final patient = widget.patient;
    _name = TextEditingController(text: patient.name);
    _startAge = TextEditingController(
      text: patient.treatmentStartAge.toString(),
    );
    _sex = TextEditingController(text: patient.sex);
    _income = TextEditingController(text: patient.income.toString());
    _elitism = TextEditingController(text: patient.elitism);
    _ethnicity = TextEditingController(text: patient.ethnicity);
    _birthPlacement = TextEditingController(text: patient.birthPlacement);
    _weight = TextEditingController(text: patient.weight.toString());
    _height = TextEditingController(text: patient.height.toString());
    _occupation = TextEditingController(text: patient.occupation);
    _education = TextEditingController(text: patient.educationLevel);
    _drugs = TextEditingController(text: patient.drugs.join(', '));
    _comorbidities = TextEditingController(
      text: patient.comorbidities.join(', '),
    );
    _exitReason = TextEditingController(text: patient.exitReason ?? '');
    _birthDate = patient.birthDate;
    _smokingLevel = patient.smokingLevel;
    _participationStatus = patient.participationStatus;

    final attributes = patient.researchAttributes.isNotEmpty
        ? patient.researchAttributes
        : widget.researchAttributes;
    for (final attribute in attributes.entries) {
      _attributeKeyControllers.add(TextEditingController(text: attribute.key));
      _attributeValueControllers.add(
        TextEditingController(text: attribute.value),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _startAge,
      _sex,
      _income,
      _elitism,
      _ethnicity,
      _birthPlacement,
      _weight,
      _height,
      _occupation,
      _education,
      _drugs,
      _comorbidities,
      _exitReason,
      ..._attributeKeyControllers,
      ..._attributeValueControllers,
      ..._retiredControllers,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _decoration(String label, ColorScheme colors) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colors.secondary),
      floatingLabelStyle: TextStyle(
        color: colors.secondary,
        fontWeight: FontWeight.w500,
      ),
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

  String? _requiredText(String? value) => value == null || value.trim().isEmpty
      ? 'Este campo é obrigatório.'
      : null;

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe um valor.';
    }
    if (double.tryParse(value.trim()) == null) {
      return 'Informe um número válido.';
    }
    return null;
  }

  String? _validateAttributeKey(int index, String? value) {
    final key = value?.trim() ?? '';
    if (key.isEmpty) return 'Informe o atributo.';
    for (
      var otherIndex = 0;
      otherIndex < _attributeKeyControllers.length;
      otherIndex++
    ) {
      if (otherIndex != index &&
          _attributeKeyControllers[otherIndex].text.trim() == key) {
        return 'Este atributo já foi informado.';
      }
    }
    return null;
  }

  List<String> _parseList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _addAttribute() {
    setState(() {
      _attributeKeyControllers.add(TextEditingController());
      _attributeValueControllers.add(TextEditingController());
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      _retiredControllers.add(_attributeKeyControllers.removeAt(index));
      _retiredControllers.add(_attributeValueControllers.removeAt(index));
    });
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final researchAttributes = <String, String>{};
    for (var index = 0; index < _attributeKeyControllers.length; index++) {
      final key = _attributeKeyControllers[index].text.trim();
      researchAttributes[key] = _attributeValueControllers[index].text.trim();
    }

    Navigator.of(context).pop(
      Patient(
        id: widget.patient.id,
        name: _name.text.trim(),
        treatmentStartAge: int.parse(_startAge.text.trim()),
        sex: _sex.text.trim(),
        income: double.parse(_income.text.trim()),
        smokingLevel: _smokingLevel,
        elitism: _elitism.text.trim(),
        ethnicity: _ethnicity.text.trim(),
        birthPlacement: _birthPlacement.text.trim(),
        birthDate: _birthDate,
        weight: double.parse(_weight.text.trim()),
        height: double.parse(_height.text.trim()),
        occupation: _occupation.text.trim(),
        educationLevel: _education.text.trim(),
        drugs: _parseList(_drugs.text),
        comorbidities: _parseList(_comorbidities.text),
        participationStatus: _participationStatus,
        exitReason: _participationStatus ? null : _exitReason.text.trim(),
        researchAttributes: researchAttributes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget textField(
      String label,
      TextEditingController controller, {
      TextInputType? keyboardType,
      String? Function(String?)? validator,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _decoration(label, colors),
          validator: validator,
        ),
      );
    }

    return AlertDialog(
      backgroundColor: colors.primary,
      title: Text(
        'Editar paciente',
        style: context.textStyles.titleLarge?.copyWith(color: colors.secondary),
      ),
      content: SizedBox(
        width: 560,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  textField('Nome', _name, validator: _requiredText),
                  textField(
                    'Idade no início do tratamento',
                    _startAge,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value.trim()) == null) {
                        return 'Informe uma idade válida.';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Data de nascimento',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: colors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _pickBirthDate,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.secondary,
                        side: BorderSide(color: colors.outline),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      icon: Icon(Icons.calendar_today, color: colors.secondary),
                      label: Text(
                        '${_birthDate.day.toString().padLeft(2, '0')}/'
                        '${_birthDate.month.toString().padLeft(2, '0')}/'
                        '${_birthDate.year}',
                        style: context.textStyles.labelMedium?.copyWith(
                          color: colors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  textField('Sexo', _sex, validator: _requiredText),
                  textField(
                    'Renda',
                    _income,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _requiredNumber,
                  ),
                  DropdownButtonFormField<SmokingLevel>(
                    initialValue: _smokingLevel,
                    decoration: _decoration('Nível de tabagismo', colors),
                    items: SmokingLevel.values
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(
                              level.displayName,
                              style: context.textStyles.bodyLarge?.withColor(
                                colors.onPrimary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _smokingLevel = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  textField('Classe social', _elitism),
                  textField('Etnia', _ethnicity),
                  textField('Local de nascimento', _birthPlacement),
                  textField(
                    'Peso (kg)',
                    _weight,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _requiredNumber,
                  ),
                  textField(
                    'Altura',
                    _height,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _requiredNumber,
                  ),
                  textField('Profissão', _occupation),
                  textField('Escolaridade', _education),
                  textField('Medicamentos (separados por vírgula)', _drugs),
                  textField(
                    'Comorbidades (separadas por vírgula)',
                    _comorbidities,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Participação ativa'),
                    value: _participationStatus,
                    onChanged: (value) {
                      setState(() => _participationStatus = value);
                    },
                  ),
                  if (!_participationStatus)
                    textField(
                      'Motivo da saída',
                      _exitReason,
                      validator: _requiredText,
                    ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Atributos da pesquisa',
                      style: context.textStyles.titleMedium?.copyWith(
                        color: colors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_attributeKeyControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _attributeKeyControllers[index],
                              decoration: _decoration('Atributo', colors),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _attributeValueControllers[index],
                              decoration: _decoration('Valor', colors),
                            ),
                          ),
                          // IconButton(
                          //   tooltip: 'Remover atributo',
                          //   onPressed: () => _removeAttribute(index),
                          //   icon: Icon(
                          //     Icons.delete_outline,
                          //     color: colors.error,
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  }),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: TextButton.icon(
                  //     onPressed: _addAttribute,
                  //     icon: Icon(Icons.add, color: colors.secondary),
                  //     label: Text(
                  //       'Adicionar atributo',
                  //       style: TextStyle(color: colors.secondary),
                  //     ),
                  //   ),
                  // ),
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
            backgroundColor: colors.secondary,
            foregroundColor: colors.primary,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
