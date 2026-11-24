import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
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
    unawaited(_loadModelData());
  }

  Future<void> _loadModelData() async {
    await _viewModel.commands.getModelQuest(widget.modelquest.id);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _viewModel.commands.loadUserPermissions(userId);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir questionário'),
        content: Text(
          'Tem certeza que deseja excluir o modelo "${widget.modelquest.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.secondary,
            ),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.secondary,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _viewModel.commands.deleteModelQuest(widget.modelquest.id);

    if (!mounted) return;

    final message = _viewModel.modelQuestState.message.value;
    if (message != null && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questionário excluído com sucesso.'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      context.pop();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.modelquest.name],
        action: Watch((context) {
          final canDelete =
              _viewModel.modelQuestState.canDeleteModelQuest.value;
          final isLoadingPermissions =
              _viewModel.modelQuestState.isLoadingPermissions.value;

          if (isLoadingPermissions || !canDelete) {
            return const SizedBox.shrink();
          }

          return PopMenu(
            sections: [
              MenuSection(
                title: 'Gerenciar',
                items: [
                  MenuAction(
                    label: 'Excluir',
                    icon: Icons.delete_outline_outlined,
                    onTap: _confirmDelete,
                  ),
                ],
              ),
            ],
          );
        }),
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
