import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/modelquest/presentation/views/modelquest_view.dart';
import 'package:medquest/modelquest/presentation/widgets/multiple_choice_question.dart';
import 'package:medquest/modelquest/presentation/widgets/open_question.dart';

void main() {
  testWidgets(
    'renders questions by type and preserves answers when navigating',
    (tester) async {
      final modelQuest = ModelQuest(
        name: 'Questionário de teste',
        questions: const [
          Question(
            id: 'choice',
            text: 'Escolha uma opção',
            type: 'multiple-choice',
            alternatives: [
              {'choice': 'Opção A', 'value': 1.5},
              {'choice': 'Opção B', 'value': 2.5},
            ],
          ),
          Question(id: 'text', text: 'Escreva sua resposta', type: 'string'),
          Question(id: 'file', text: 'Envie um arquivo', type: 'file'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: ModelQuestView(modelquest: modelQuest)),
      );

      expect(find.byType(MultipleChoiceQuestion), findsOneWidget);
      expect(find.text('Escolha uma opção'), findsOneWidget);

      await tester.tap(find.text('Opção A (1.5)'));
      await tester.pump();
      await tester.tap(find.text('Próxima'));
      await tester.pumpAndSettle();

      expect(find.byType(OpenQuestion), findsOneWidget);
      expect(find.text('Escreva sua resposta'), findsOneWidget);
      final answerField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Digite a resposta',
      );
      await tester.enterText(answerField, 'Resposta salva');
      await tester.pump();

      await tester.tap(find.text('Anterior'));
      await tester.pumpAndSettle();
      expect(find.byType(MultipleChoiceQuestion), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

      await tester.tap(find.text('Próxima'));
      await tester.pumpAndSettle();
      expect(
        (tester.widget<TextField>(answerField).controller!).text,
        'Resposta salva',
      );

      await tester.tap(find.text('Próxima'));
      await tester.pumpAndSettle();
      expect(find.text('Envie um arquivo'), findsOneWidget);
      expect(find.text('Arquivo'), findsOneWidget);
    },
  );
}
