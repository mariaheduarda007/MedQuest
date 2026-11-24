import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquests_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_title.dart';
import 'package:medquest/research/presentation/widgets/list_item.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/modelquest/presentation/views/create_modelquest_view.dart';

class ModelQuestsView extends StatefulWidget {
  const ModelQuestsView({super.key, required this.session});

  final AuthSession session;

  @override
  State<ModelQuestsView> createState() => _ModelQuestsViewState();
}

class _ModelQuestsViewState extends State<ModelQuestsView> {
  late final ModelQuestsViewModel _viewModel;
  late final PermissionCacheService permissions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<ModelQuestsViewModel>();
    unawaited(_loadModelQuests());
  }

  Future<void> _loadModelQuests() async {
    final state = _viewModel.modelQuestsState;
    state.setModelQuests([]);
    state.clearMessage();

    if (mounted) {
      setState(() => _isLoading = true);
    }

    await _viewModel.commands.getAllModelQuests();

    if (mounted) {
      setState(() => _isLoading = false);
    }
    await _viewModel.commands.loadUserPermissions(widget.session.user.uid);
  }

  void canCreateModelQuest() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Watch((context) {
              final canCreate =
                  _viewModel.modelQuestsState.canCreateModelQuest.value;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: HeaderTitle(
                  title: 'Seus Modelos',
                  buttonTitle: canCreate ? '+ Modelo' : null,
                  onPressed: canCreate
                      ? () async {
                          await context.push('/modelquest/create');
                          await _loadModelQuests();
                        }
                      : null,
                ),
              );
            }),
            Expanded(
              child: Watch((context) {
                final state = _viewModel.modelQuestsState;
                final isLoading =
                    _isLoading ||
                    _viewModel
                        .commands
                        .getAllModelQuestsCommand
                        .isExecuting
                        .value;
                final modelQuests = state.modelQuestsState.value;

                if (isLoading && modelQuests.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (modelQuests.isEmpty) {
                  return Center(
                    child: Text(
                      state.message.value ?? 'Nenhum questionário encontrado.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadModelQuests,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: modelQuests.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final modelQuest = modelQuests[index];
                      final questionCount = modelQuest.questions.length;
                      final questionLabel = questionCount == 1
                          ? 'pergunta'
                          : 'perguntas';

                      return ListItem(
                        icon: Icons.edit_note,
                        title: modelQuest.name,
                        subtitle: '$questionCount $questionLabel',
                        onTap: () async {
                          await context.pushNamed(
                            MedQuestRouteNames.modelquest,
                            extra: modelQuest,
                          );
                          await _loadModelQuests();
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
