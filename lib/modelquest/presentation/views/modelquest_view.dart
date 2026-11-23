import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_viewmodel.dart';
import 'package:medquest/modelquest/presentation/widgets/multiple_choice_question.dart';
import 'package:medquest/modelquest/presentation/widgets/open_question.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/research/presentation/widgets/pop_menu.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ModelQuestView extends StatefulWidget {
  const ModelQuestView({super.key, required this.modelquest});

  final ModelQuest modelquest;

  @override
  State<ModelQuestView> createState() => _ModelQuestViewState();
}

class _ModelQuestViewState extends State<ModelQuestView> {
  late final ModelQuestViewModel _viewModel;
  // late final PermissionCacheService permissions;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<ModelQuestViewModel>();
    unawaited(_loadModelQuest());
  }

  Widget _buildQuestion(Question question, int index) {
    switch (question.type) {
      case 'multiple-choice':
        return MultipleChoiceQuestion(
          enabled: true,
          key: ValueKey(question.id),
          numeration: index + 1,
          title: question.text,
          orientation: question.orientation,
          choices: question.alternatives
              .map((alternative) => alternative['choice'] as String)
              .toList(),
          values: question.alternatives
              .map((alternative) => (alternative['value'] as num).toInt())
              .toList(),
        );

      case 'string':
        return OpenQuestion(
          enabled: false,
          key: ValueKey(question.id),
          type: AnswerType.text,
          title: question.text,
          numeration: index + 1,
          orientation: question.orientation,
        );

      case 'file':
        return OpenQuestion(
          enabled: false,
          key: ValueKey(question.id),
          type: AnswerType.file,
          title: question.text,
          numeration: index + 1,
          orientation: question.orientation,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _loadModelQuest() async {
    await _viewModel.commands.getModelQuest(widget.modelquest.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.modelquest.name],
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
      bottomNavigationBar: const BottomMenuBar(initialIndex: 2),

      body: Watch((context) {
        final modelQuest = _viewModel.modelQuestState.state.value;

        if (modelQuest == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    modelQuest.name,
                    style: context.textStyles.headlineLarge?.semiBold.withColor(
                      context.colors.onPrimary,
                    ),
                  ),
                ),

                ...List.generate(
                  modelQuest.questions.length,
                  (index) => _buildQuestion(modelQuest.questions[index], index),
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
