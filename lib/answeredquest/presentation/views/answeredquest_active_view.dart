import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_attachment.dart';
import 'package:medquest/answeredquest/domain/models/question_entity.dart'
    as answered;
import 'package:medquest/answeredquest/presentation/controllers/answeredquest_viewmodel.dart';
import 'package:medquest/answeredquest/presentation/widgets/score_card.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/modelquest/presentation/widgets/multiple_choice_question.dart';
import 'package:medquest/modelquest/presentation/widgets/open_question.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';

class AnsweredQuestActiveView extends StatefulWidget {
  const AnsweredQuestActiveView({
    super.key,
    required this.modelquest,
    required this.research,
    required this.group,
    required this.patient,
  });

  final ModelQuest modelquest;
  final Research research;
  final Group group;
  final Patient patient;

  @override
  State<AnsweredQuestActiveView> createState() =>
      _AnsweredQuestActiveViewState();
}

class _AnsweredQuestActiveViewState extends State<AnsweredQuestActiveView> {
  int _currentQuestionIndex = 0;
  bool _showScore = false;
  bool _isSaving = false;
  final Map<String, _QuestionAnswer> _answers = {};
  late final AnsweredQuestViewModel _viewModel;
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<AnsweredQuestViewModel>();
    _authViewModel = injector.get<AuthViewModel>();
  }

  String _questionKey(int index) {
    final id = widget.modelquest.questions[index].id;
    return id.isEmpty ? 'index:$index' : id;
  }

  _QuestionAnswer _answerFor(int index) {
    return _answers.putIfAbsent(_questionKey(index), _QuestionAnswer.new);
  }

  Widget _buildQuestion(int index, Question question) {
    final answer = _answerFor(index);
    final key = ValueKey(_questionKey(index));

    switch (question.type.trim().toLowerCase()) {
      case 'multiple-choice':
        if (question.alternatives.isEmpty) {
          return const Text('Esta questão não possui alternativas.');
        }

        final choices = <String>[];
        final values = <num>[];
        for (final alternative in question.alternatives) {
          final value = alternative['value'];
          if (value is! num) {
            return const Text('Uma alternativa possui valor inválido.');
          }
          choices.add(alternative['choice']?.toString() ?? '');
          values.add(value);
        }

        return MultipleChoiceQuestion(
          key: key,
          numeration: index + 1,
          title: question.text,
          choices: choices,
          enabled: true,
          values: values,
          selectedValue: answer.selectedValue,
          onChanged: (value) {
            setState(() => answer.selectedValue = value);
          },
        );
      case 'string':
      case 'file':
        return OpenQuestion(
          key: key,
          type: question.type.trim().toLowerCase() == 'file'
              ? AnswerType.file
              : AnswerType.text,
          title: question.text,
          numeration: index + 1,
          answer: answer.text,
          value: answer.score,
          selectedFile: answer.file,
          enabled: true,
          onChanged: (text, score) {
            setState(() {
              answer.text = text;
              answer.score = score;
            });
          },
          onFileChanged: (file) {
            setState(() => answer.file = file);
          },
        );
      default:
        return Text('Tipo de questão não suportado: ${question.type}');
    }
  }

  void _showPreviousQuestion() {
    if (_currentQuestionIndex == 0) return;
    setState(() => _currentQuestionIndex--);
  }

  void _showNextQuestion() {
    if (_currentQuestionIndex >= widget.modelquest.questions.length - 1) {
      return;
    }
    setState(() => _currentQuestionIndex++);
  }

  num get _totalScore {
    num total = 0;
    for (int i = 0; i < widget.modelquest.questions.length; i++) {
      final answer = _answers[_questionKey(i)];
      if (answer?.selectedValue != null) {
        total += answer!.selectedValue!;
      } else if (answer?.score != null) {
        total += answer!.score!;
      }
    }
    return total;
  }

  String get _researcherName {
    final name = _authViewModel.session.session.value?.user.name.trim();
    return name == null || name.isEmpty ? 'Usuário não identificado' : name;
  }

  void _finish() {
    setState(() => _showScore = true);
  }

  Future<void> _save() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Salvando questionário...')));

    try {
      final answeredQuestions = <answered.Question>[];
      final attachments = <AnsweredQuestAttachment>[];
      for (int i = 0; i < widget.modelquest.questions.length; i++) {
        final modelQuestion = widget.modelquest.questions[i];
        final answer = _answerFor(i);
        String? textAnswer;

        if (answer.selectedValue != null) {
          for (final alternative in modelQuestion.alternatives) {
            if (alternative['value'] == answer.selectedValue) {
              textAnswer = alternative['choice']?.toString();
              break;
            }
          }
        } else if (answer.file != null) {
          textAnswer = answer.file!.name;
          attachments.add(
            AnsweredQuestAttachment(
              questionIndex: i,
              fileName: answer.file!.name,
              bytes: await answer.file!.readAsBytes(),
            ),
          );
        } else {
          textAnswer = answer.text.isEmpty ? null : answer.text;
        }

        final score = answer.selectedValue ?? answer.score;
        answeredQuestions.add(
          answered.Question(
            idModelQuestion: modelQuestion.id,
            answer: textAnswer,
            score: score,
          ),
        );
      }

      final answeredQuest = AnsweredQuest(
        idModelQuest: widget.modelquest.id,
        questions: answeredQuestions,
        name: widget.modelquest.name,
      );
      final patientIdParams = (
        researchId: widget.research.id,
        groupId: widget.group.id,
        patientId: widget.patient.id,
      );
      final params = (
        answeredQuest: answeredQuest,
        patientIdParams: patientIdParams,
        attachments: attachments,
      );

      final result = await _viewModel.commands.createAnsweredQuest(params);
      if (!mounted) return;

      setState(() => _isSaving = false);
      result.fold(
        onSuccess: (_) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Questionário salvo com sucesso!')),
            );
        },
        onFailure: (failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Erro ao salvar: ${failure.msg}')),
            );
        },
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Erro ao salvar: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.modelquest.questions;

    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 1),
      body: SafeArea(
        child: _showScore
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ResearcherScoreCard(
                      score: _totalScore,
                      researcher: _researcherName,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colors.onPrimary,
                        foregroundColor: context.colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // textStyle: const TextStyle(
                        //   fontSize: 17,
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ],
                ),
              )
            : questions.isEmpty
            ? const Center(
                child: Text('Este questionário não possui questões.'),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.modelquest.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Questão ${_currentQuestionIndex + 1} de ${questions.length}',
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildQuestion(
                        _currentQuestionIndex,
                        questions[_currentQuestionIndex],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _currentQuestionIndex > 0
                              ? _showPreviousQuestion
                              : null,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.onPrimary,
                            side: BorderSide(
                              color: context.colors.onPrimary,
                              width: 2,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Anterior'),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.onPrimary,
                            foregroundColor: context.colors.primary,
                          ),
                          onPressed:
                              _currentQuestionIndex < questions.length - 1
                              ? _showNextQuestion
                              : _finish,
                          icon: Icon(
                            _currentQuestionIndex < questions.length - 1
                                ? Icons.arrow_forward
                                : Icons.check,
                          ),
                          label: Text(
                            _currentQuestionIndex < questions.length - 1
                                ? 'Próxima'
                                : 'Finalizar',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _QuestionAnswer {
  num? selectedValue;
  String text = '';
  num? score;
  PlatformFile? file;
}
