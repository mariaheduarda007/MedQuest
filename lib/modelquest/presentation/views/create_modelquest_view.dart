import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_viewmodel.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquests_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';

enum QuestionKind { open, multipleChoice, file }

class _DraftAlternative {
  final TextEditingController answerController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  void dispose() {
    answerController.dispose();
    valueController.dispose();
  }
}

class _DraftQuestion {
  QuestionKind kind;
  final TextEditingController orientationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController openValueController = TextEditingController();
  final List<_DraftAlternative> alternatives;

  _DraftQuestion({required this.kind})
    : alternatives = [_DraftAlternative(), _DraftAlternative()];

  void dispose() {
    orientationController.dispose();
    titleController.dispose();
    openValueController.dispose();
    for (final alternative in alternatives) {
      alternative.dispose();
    }
  }
}

class CreateModelQuestView extends StatefulWidget {
  const CreateModelQuestView({super.key});

  @override
  State<CreateModelQuestView> createState() => _CreateModelQuestViewState();
}

class _CreateModelQuestViewState extends State<CreateModelQuestView> {
  final _nameController = TextEditingController();
  final _questions = <_DraftQuestion>[];
  late final ModelQuestViewModel _viewModel;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<ModelQuestViewModel>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: context.textStyles.labelLarge?.withColor(
      context.colors.onPrimary,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: context.colors.onPrimary, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: context.colors.onPrimary, width: 1.5),
    ),
  );

  void _addQuestion(QuestionKind kind) {
    setState(() => _questions.add(_DraftQuestion(kind: kind)));
  }

  Widget _buildQuestionCard(_DraftQuestion question, int index) {
    final isOpen = question.kind == QuestionKind.open;
    final isFile = question.kind == QuestionKind.file;
    final isMultipleChoice = question.kind == QuestionKind.multipleChoice;

    return Card(
      color: context.colors.primary,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pergunta ${index + 1}',
                    style: context.textStyles.titleMedium?.semiBold.withColor(
                      context.colors.onPrimary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Excluir pergunta',
                  onPressed: () {
                    setState(() {
                      question.dispose();
                      _questions.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: question.orientationController,
              maxLines: 3,
              decoration: _decoration('Orientação (opcional)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: question.titleController,
              decoration: _decoration('Título da pergunta'),
            ),
            const SizedBox(height: 12),

            if (isMultipleChoice)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < question.alternatives.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller:
                                  question.alternatives[i].answerController,
                              decoration: _decoration('Resposta ${i + 1}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller:
                                  question.alternatives[i].valueController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              decoration: _decoration('Value'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  OutlinedButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colors.tertiary,
                      foregroundColor: context.colors.primary,
                    ),
                    onPressed: () => setState(
                      () => question.alternatives.add(_DraftAlternative()),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar resposta'),
                  ),
                ],
              ),
            if (isFile)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.upload_file, color: context.colors.secondary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('O pesquisador poderá enviar um arquivo.'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _finishCreation() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Informe o nome do modelo.');
      return;
    }
    if (_questions.isEmpty) {
      _showMessage('Adicione pelo menos uma pergunta.');
      return;
    }

    for (final question in _questions) {
      if (question.titleController.text.trim().isEmpty) {
        _showMessage('Preencha o título de todas as perguntas.');
        return;
      }

      if (question.kind == QuestionKind.multipleChoice) {
        final invalidAlternative = question.alternatives.any(
          (alternative) =>
              alternative.answerController.text.trim().isEmpty ||
              num.tryParse(alternative.valueController.text.trim()) == null,
        );
        if (invalidAlternative) {
          _showMessage(
            'Preencha todas as respostas e values das perguntas de múltipla escolha.',
          );
          return;
        }
      }
    }

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final questions = <Question>[];
      for (final draft in _questions) {
        final isOpen = draft.kind == QuestionKind.open;
        final isFile = draft.kind == QuestionKind.file;
        final alternatives = isOpen || isFile
            ? <Map<String, dynamic>>[]
            : draft.alternatives
                  .map(
                    (alternative) => <String, dynamic>{
                      'choice': alternative.answerController.text.trim(),
                      'value': num.parse(
                        alternative.valueController.text.trim(),
                      ),
                    },
                  )
                  .toList();

        if (isOpen) {
          final openValue = num.tryParse(draft.openValueController.text.trim());
          if (openValue != null) {
            alternatives.add(<String, dynamic>{
              'choice': '',
              'value': openValue,
            });
          }
        }

        questions.add(
          Question(
            text: draft.titleController.text.trim(),
            type: isOpen
                ? 'string'
                : isFile
                ? 'file'
                : 'multiple-choice',
            alternatives: alternatives,
            orientation: draft.orientationController.text.trim().isEmpty
                ? null
                : draft.orientationController.text.trim(),
          ),
        );
      }

      await _viewModel.commands.createModelQuest(
        ModelQuest(name: name, questions: questions),
      );

      final created = _viewModel.modelQuestState.state.value;
      if (created == null || created.id.isEmpty) {
        throw Exception(
          _viewModel.modelQuestState.message.value ??
              'Não foi possível criar o modelo.',
        );
      }

      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Modelo criado com sucesso!')),
        );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Erro ao criar modelo: $error')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderRoute(route: ['Seus Modelos', 'Novo modelo']),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Criar modelo de questionário',
                      style: context.textStyles.titleMedium?.semiBold.withColor(
                        context.colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _nameController,
                      decoration: _decoration('Nome do modelo'),
                    ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < _questions.length; i++)
                      _buildQuestionCard(_questions[i], i),
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.tertiary,
                            foregroundColor: context.colors.primary,
                          ),
                          onPressed: _isSaving
                              ? null
                              : () => _addQuestion(QuestionKind.open),
                          icon: const Icon(Icons.short_text),
                          label: const Text('Pergunta aberta'),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.tertiary,
                            foregroundColor: context.colors.primary,
                          ),
                          onPressed: _isSaving
                              ? null
                              : () => _addQuestion(QuestionKind.multipleChoice),
                          icon: const Icon(Icons.radio_button_checked),
                          label: const Text('Múltipla escolha'),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.tertiary,
                            foregroundColor: context.colors.primary,
                          ),
                          onPressed: _isSaving
                              ? null
                              : () => _addQuestion(QuestionKind.file),
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Arquivo'),
                        ),
                      ],
                    ),
                    if (_questions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: context.colors.onPrimary,
                          foregroundColor: context.colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _isSaving ? null : _finishCreation,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Finalizar criação'),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
