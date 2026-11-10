import 'package:flutter/material.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/domain/models/question_entity.dart';
import 'package:medquest/answeredquest/presentation/controllers/answeredquest_viewmodel.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:signals_flutter/signals_flutter.dart';

const _researchId = 'RjLSlXYoZjbocCPObGEG';
const _groupId = 'placebo';
const _patientId = 'UFRCkj9aIVRAPx78Rga2';

const _fakeAnsweredQuest = AnsweredQuest(
  idModelQuest: 'modelquest-teste',
  questions: [
    Question(idModelQuestion: 'question-teste-1', answer: 'Resposta de teste'),
    Question(
      idModelQuestion: 'question-teste-2',
      answer: 'Outra resposta teste',
    ),
  ],
);

class ResearchesPage extends StatefulWidget {
  const ResearchesPage({super.key});

  @override
  State<ResearchesPage> createState() => _ResearchesPageState();
}

class _ResearchesPageState extends State<ResearchesPage> {
  late final AnsweredQuestViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = injector.get<AnsweredQuestViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createAnsweredQuest();
    });
  }

  Future<void> _createAnsweredQuest() async {
    _viewModel.answeredQuestState.setAnsweredQuest(null);
    _viewModel.answeredQuestState.setMessage(
      'Criando AnsweredQuest de teste...',
    );

    await _viewModel.commands.getAnsweredQuest((
      researchId: _researchId,
      groupId: _groupId,
      patientId: _patientId,
      answeredQuestId: 'vPvgQvXMm1TELWk0MYbo',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Watch((context) {
          final state = _viewModel.answeredQuestState;
          final answeredQuest = state.state.value;
          final message = state.message.value;

          final isLoading =
              _viewModel.commands.getAnsweredQuestCommand.isExecuting.value;

          if (isLoading && answeredQuest == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (answeredQuest == null && message != null && message.isNotEmpty) {
            return Center(child: Text(message));
          }

          if (answeredQuest == null) {
            return const Center(child: Text('Questionário não encontrado.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading) const LinearProgressIndicator(),
                if (message != null && message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(message),
                  ),
                const Text('AnsweredQuest buscado:'),
                Text('ID: ${answeredQuest.id}'),
                Text('ModelQuest: ${answeredQuest.idModelQuest}'),
                const SizedBox(height: 12),

                for (final question in answeredQuest.questions)
                  ListTile(title: Text(question.toString())),
              ],
            ),
          );
        }),
      ),
    );
  }
}
