import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/modelquest/presentation/widgets/multiple_choice_question.dart';
import 'package:medquest/modelquest/presentation/widgets/open_question.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';

class AnsweredQuestView extends StatefulWidget {
  const AnsweredQuestView({super.key, required this.modelquest});

  final ModelQuest modelquest;

  @override
  State<AnsweredQuestView> createState() => _AnsweredQuestViewState();
}

class _AnsweredQuestViewState extends State<AnsweredQuestView> {
  int _currentQuestionIndex = 0;
  final Map<String, _QuestionAnswer> _answers = {};

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

  @override
  Widget build(BuildContext context) {
    final questions = widget.modelquest.questions;

    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 2),
      body: SafeArea(
        child: questions.isEmpty
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
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Anterior'),
                        ),
                        FilledButton.icon(
                          onPressed:
                              _currentQuestionIndex < questions.length - 1
                              ? _showNextQuestion
                              : null,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Próxima'),
                          
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
