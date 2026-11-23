import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/domain/models/question_entity.dart'
    as answered;
import 'package:medquest/answeredquest/presentation/controllers/answeredquest_viewmodel.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_viewmodel.dart';
import 'package:medquest/modelquest/presentation/widgets/multiple_choice_question.dart';
import 'package:medquest/modelquest/presentation/widgets/open_question.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/research/presentation/widgets/pop_menu.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnsweredQuestInactiveView extends StatefulWidget {
  const AnsweredQuestInactiveView({
    super.key,
    required this.answeredQuest,
    required this.modelquest,
    required this.researchId,
    required this.groupId,
    required this.patientId,
  });

  final AnsweredQuest answeredQuest;
  final ModelQuest modelquest;
  final String researchId;
  final String groupId;
  final String patientId;

  @override
  State<AnsweredQuestInactiveView> createState() =>
      _AnsweredQuestInactiveViewState();
}

class _AnsweredQuestInactiveViewState extends State<AnsweredQuestInactiveView> {
  late final ModelQuestViewModel _modelViewModel;
  late final AnsweredQuestViewModel _answeredViewModel;

  @override
  void initState() {
    super.initState();
    _modelViewModel = injector.get<ModelQuestViewModel>();
    _answeredViewModel = injector.get<AnsweredQuestViewModel>();
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    final params = (
      researchId: widget.researchId,
      groupId: widget.groupId,
      patientId: widget.patientId,
      answeredQuestId: widget.answeredQuest.id,
    );

    await Future.wait([
      _modelViewModel.commands.getModelQuest(widget.modelquest.id),
      _answeredViewModel.commands.getAnsweredQuest(params),
    ]);
  }

  Widget _buildQuestion(
    Question modelQuestion,
    int index,
    AnsweredQuest currentAnswered,
  ) {
    final answered.Question? answeredQuestion = currentAnswered.questions
        .where((q) => q.idModelQuestion == modelQuestion.id)
        .firstOrNull;

    switch (modelQuestion.type) {
      case 'multiple-choice':
        final choices = modelQuestion.alternatives
            .map((alternative) => alternative['choice'] as String)
            .toList();
        final values = modelQuestion.alternatives
            .map((alternative) => (alternative['value'] as num).toInt())
            .toList();

        num? selectedValue = answeredQuestion?.score;
        if (selectedValue == null && answeredQuestion?.answer != null) {
          final choiceIndex = choices.indexOf(answeredQuestion!.answer!);
          if (choiceIndex != -1) {
            selectedValue = values[choiceIndex];
          }
        }

        return MultipleChoiceQuestion(
          enabled: false,
          key: ValueKey('${modelQuestion.id}_$selectedValue'),
          numeration: index + 1,
          title: modelQuestion.text,
          choices: choices,
          values: values,
          selectedValue: selectedValue,
        );

      case 'string':
        return OpenQuestion(
          enabled: false,
          key: ValueKey('${modelQuestion.id}_${answeredQuestion?.answer}'),
          type: AnswerType.text,
          title: modelQuestion.text,
          numeration: index + 1,
          answer: answeredQuestion?.answer ?? 'Sem resposta registrada',
          value: null,
          showValueField: false,
        );

      case 'file':
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ${modelQuestion.text}',
                style: context.textStyles.titleSmall?.withColor(
                  context.colors.secondary,
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<String?>(
                future:
                    answeredQuestion?.answer != null &&
                        answeredQuestion!.answer!.isNotEmpty
                    ? FirebaseStorage.instance
                          .refFromURL(answeredQuestion.answer!)
                          .getDownloadURL()
                    : Future.value(null),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final imageUrl = snapshot.data;

                  if (imageUrl == null) {
                    return const Text('Nenhuma imagem anexada.');
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Text('Erro ao carregar a imagem do arquivo.'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.answeredQuest.name],
        action: PopMenu(
          sections: [
            MenuSection(
              title: 'Gerenciar',
              items: [
                MenuAction(
                  label: 'Excluir',
                  icon: Icons.delete_outline_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 1),
      body: Watch((context) {
        final modelQuest =
            _modelViewModel.modelQuestState.modelQuestState.value;
        final answeredQuest =
            _answeredViewModel.answeredQuestState.state.value ??
            widget.answeredQuest;

        if (modelQuest == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final totalScore = answeredQuest.questions.fold<num>(
          0,
          (sum, q) => sum + (q.score ?? 0),
        );

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        answeredQuest.name,
                        style: context.textStyles.headlineLarge?.semiBold
                            .withColor(context.colors.onPrimary),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.secondary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'Score total: $totalScore',
                          style: context.textStyles.titleSmall?.semiBold
                              .withColor(context.colors.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  modelQuest.questions.length,
                  (index) => _buildQuestion(
                    modelQuest.questions[index],
                    index,
                    answeredQuest,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
