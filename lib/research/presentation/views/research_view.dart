import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/edit_research_dialog.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/group_card.dart';
import 'package:medquest/research/presentation/controllers/research_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/pop_menu.dart';
import 'package:medquest/research/presentation/widgets/info_card.dart';
import 'package:medquest/research/presentation/widgets/score_chart.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/research/presentation/widgets/category_chart.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/presentation/controllers/userRole_viewmodel.dart';

class ResearchView extends StatefulWidget {
  const ResearchView({super.key, required this.research});

  final Research research;

  @override
  State<ResearchView> createState() => _ResearchViewState();
}

class _ResearchViewState extends State<ResearchView> {
  late final ResearchViewModel viewModel;
  late final UserRoleViewModel _userRoleViewModel;
  late final PermissionCacheService _permissionCacheService;
  late final AuthViewModel _authViewModel;
  late Research _research;
  String _researchRole = 'pesquisador';

  @override
  void initState() {
    super.initState();
    _research = widget.research;
    viewModel = injector.get<ResearchViewModel>();
    _userRoleViewModel = injector.get<UserRoleViewModel>();
    _permissionCacheService = injector.get<PermissionCacheService>();
    _authViewModel = injector.get<AuthViewModel>();
    viewModel.researchState.setGroups([]);
    viewModel.researchState.setModelQuests([]);
    viewModel.researchState.clearGroupsMessage();
    viewModel.researchState.clearModelQuestsMessage();
    viewModel.commands.getScoreChartDataCommand.executeWith((
      researchId: widget.research.id,
    ));
    unawaited(_loadGroups());
    unawaited(_loadModelQuests());
    unawaited(_loadResearchRole());
  }

  Future<void> _loadResearchRole() async {
    final userId = _authViewModel.session.session.value?.user.uid.trim();
    if (userId == null || userId.isEmpty) {
      return;
    }

    await _permissionCacheService.loadPermissions();
    await _userRoleViewModel.commands.fetchUserRoles(userId);
    if (!mounted) return;

    final permissions = _permissionCacheService.allPermissions;
    final roles = _userRoleViewModel.userRoleState.state.value;
    String role = 'pesquisador';

    for (final userRole in roles) {
      final researchId = userRole.researchId?.trim();
      if (researchId != null &&
          researchId.isNotEmpty &&
          researchId != _research.id) {
        continue;
      }

      final roleName = permissions?[userRole.permissionId]?['roleName']
          ?.toString()
          .toLowerCase()
          .trim();
      if (roleName == null || roleName.isEmpty) continue;

      if (roleName.contains('administrador') || roleName.contains('admin')) {
        role = 'administrador';
        break;
      }
      if (roleName.contains('coordenador')) {
        role = 'coordenador';
      }
    }

    setState(() {
      _researchRole = role;
    });
  }

  Future<void> _loadGroups() async {
    await viewModel.commands.getGroups(_research.id);
  }

  Future<void> _loadModelQuests() async {
    await viewModel.commands.getModelQuestsFromResearch(_research.id);
  }

  Future<ModelQuest?> _showModelQuestSelectionDialog() async {
    await viewModel.commands.getAllModelQuests();
    if (!mounted) return null;

    final availableModelQuests =
        viewModel.researchState.modelQuestsState.value
            .where((modelQuest) => !_research.quests.contains(modelQuest.id))
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    return showDialog<ModelQuest>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar questionário'),
          content: SizedBox(
            width: 420,
            height: 360,
            child: availableModelQuests.isEmpty
                ? const Center(
                    child: Text(
                      'Não há outros questionários disponíveis.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    itemCount: availableModelQuests.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final modelQuest = availableModelQuests[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF53284F),
                          child: Icon(
                            Icons.assignment_outlined,
                            color: Color(0xFFFFFCEE),
                          ),
                        ),
                        title: Text(modelQuest.name),
                        subtitle: Text(
                          '${modelQuest.questions.length} ${modelQuest.questions.length == 1 ? 'pergunta' : 'perguntas'}',
                        ),
                        onTap: () =>
                            Navigator.of(dialogContext).pop(modelQuest),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addModelQuest() async {
    final messenger = ScaffoldMessenger.of(context);
    final modelQuest = await _showModelQuestSelectionDialog();
    if (modelQuest == null || !mounted) return;

    messenger.showSnackBar(
      const SnackBar(content: Text('Adicionando questionário...')),
    );

    final updatedResearch = _research.copyWith(
      quests: [..._research.quests, modelQuest.id],
    );
    final result = await viewModel.commands.updateResearch(updatedResearch);

    if (!mounted) return;
    result.fold(
      onSuccess: (savedResearch) {
        setState(() => _research = savedResearch);
        unawaited(_loadModelQuests());
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${modelQuest.name} adicionado à pesquisa.'),
            ),
          );
      },
      onFailure: (failure) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Erro ao adicionar questionário: ${failure.msg}'),
            ),
          );
      },
    );
  }

  Future<User?> _showUserSelectionDialog(String roleLabel) async {
    final snapshot = await FirebaseFirestore.instance.collection('User').get();
    if (!mounted) return null;
    final currentUserId = _authViewModel.session.session.value?.user.uid.trim();
    final users =
        snapshot.docs
            .map((document) {
              final data = Map<String, dynamic>.from(document.data());
              data['uid'] = data['uid']?.toString().isNotEmpty == true
                  ? data['uid'].toString()
                  : document.id;
              return User(
                uid: data['uid'].toString(),
                name: data['name']?.toString().trim().isNotEmpty == true
                    ? data['name'].toString().trim()
                    : data['email']?.toString().trim() ?? 'Usuário',
                email: data['email']?.toString().trim() ?? '',
              );
            })
            .where((user) => user.uid.trim() != currentUserId)
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    if (!mounted) return null;

    return showDialog<User>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Selecionar $roleLabel'),
          content: SizedBox(
            width: 420,
            height: 360,
            child: users.isEmpty
                ? const Center(child: Text('Nenhum usuário encontrado.'))
                : ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF53284F),
                          child: Icon(
                            Icons.person_outline,
                            color: Color(0xFFFFFCEE),
                          ),
                        ),
                        title: Text(user.name),
                        subtitle: user.email.isNotEmpty
                            ? Text(user.email)
                            : null,
                        onTap: () => Navigator.of(dialogContext).pop(user),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _permissionIdForRole(String roleLabel) async {
    await _permissionCacheService.loadPermissions();
    final permissions = _permissionCacheService.allPermissions;
    if (permissions == null) return null;

    final normalizedLabel = roleLabel.toLowerCase();
    for (final entry in permissions.entries) {
      final roleName = entry.value['roleName']?.toString().toLowerCase() ?? '';
      if (roleName.contains(normalizedLabel)) {
        return entry.key;
      }
    }

    if (normalizedLabel.contains('pesquisador')) {
      return 'l3vfhlDfZnuccsM1gUY2';
    }
    return null;
  }

  Future<void> _addUserRole(String roleLabel) async {
    final messenger = ScaffoldMessenger.of(context);
    final user = await _showUserSelectionDialog(roleLabel);
    if (user == null || !mounted) return;

    final permissionId = await _permissionIdForRole(roleLabel);
    if (permissionId == null) {
      messenger.showSnackBar(
        SnackBar(content: Text('Permissão de $roleLabel não encontrada.')),
      );
      return;
    }

    await _userRoleViewModel.commands.fetchAllUserRoles();
    final alreadyAssigned = _userRoleViewModel.userRoleState.state.value.any(
      (role) =>
          role.userId == user.uid &&
          role.permissionId == permissionId &&
          role.researchId == _research.id,
    );
    if (alreadyAssigned) {
      messenger.showSnackBar(
        SnackBar(content: Text('${user.name} já é $roleLabel nesta pesquisa.')),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text('Adicionando $roleLabel...')),
    );
    await _userRoleViewModel.commands.createUserRole(
      userId: user.uid,
      permissionId: permissionId,
      researchId: _research.id,
    );

    if (!mounted) return;
    final error = _userRoleViewModel.userRoleState.message.value;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            error == null
                ? '${user.name} adicionado como $roleLabel.'
                : 'Erro ao adicionar $roleLabel: $error',
          ),
        ),
      );
  }

  Future<void> _addGroup() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Criando grupo...')));

    try {
      final groupNumber = viewModel.researchState.groupsState.value.length + 1;
      final result = await viewModel.commands.createGroup(
        researchId: _research.id,
        group: Group(name: 'Grupo ${groupNumber.toString()}'),
      );

      result.fold(
        onSuccess: (_) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Grupo adicionado com sucesso!')),
            );
        },
        onFailure: (error) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Erro ao adicionar grupo: ${error.msg}')),
            );
        },
      );
    } catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Erro ao adicionar grupo: $error')),
        );
    }
  }

  Future<Research?> _showEditResearchDialog() {
    return showDialog<Research>(
      context: context,
      builder: (_) => EditResearchDialog(research: _research),
    );
  }

  Future<void> _editResearch() async {
    final messenger = ScaffoldMessenger.of(context);
    final updatedResearch = await _showEditResearchDialog();
    if (updatedResearch == null) return;

    messenger.showSnackBar(
      const SnackBar(content: Text('Salvando pesquisa...')),
    );

    try {
      final result = await viewModel.commands.updateResearch(updatedResearch);
      result.fold(
        onSuccess: (savedResearch) {
          if (mounted) {
            setState(() => _research = savedResearch);
          }
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Pesquisa atualizada com sucesso!')),
            );
        },
        onFailure: (error) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Erro ao atualizar: ${error.msg}')),
            );
        },
      );
    } catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Erro ao atualizar: $error')));
    }
  }

  Future<void> deleteResearch() async {
    try {
      await viewModel.commands.deleteResearch(_research.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pesquisa excluída com sucesso!'),
          backgroundColor: context.colors.secondary,
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir: $e'),
          backgroundColor: context.colors.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final researchAttributes = _research.researchAttributes.entries.toList();
    final isAdministrator = _researchRole == 'administrador';
    final isCoordinator = _researchRole == 'coordenador';
    final canCoordinate = isAdministrator || isCoordinator;

    final addItems = canCoordinate
        ? <MenuAction>[
            MenuAction(
              label: 'Grupo',
              icon: Icons.group_add_outlined,
              onTap: () => unawaited(_addGroup()),
            ),
            MenuAction(
              label: 'Questionário',
              icon: Icons.assignment_add,
              onTap: () => unawaited(_addModelQuest()),
            ),
            MenuAction(
              label: 'Pesquisador',
              icon: Icons.person_add_alt_1,
              onTap: () => unawaited(_addUserRole('pesquisador')),
            ),
            MenuAction(
              label: 'Coordenador',
              icon: Icons.person_add,
              onTap: () => unawaited(_addUserRole('coordenador')),
            ),
          ]
        : <MenuAction>[];

    final manageItems = <MenuAction>[
      if (isAdministrator)
        _research.archived
            ? MenuAction(
                label: 'Desarquivar',
                icon: Icons.unarchive_outlined,
                onTap: () {
                  try {
                    viewModel.commands.unarchiveResearch(_research.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pesquisa desarquivada com sucesso!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao desarquivar: $e')),
                    );
                  }
                },
              )
            : MenuAction(
                label: 'Arquivar',
                icon: Icons.archive_outlined,
                onTap: () {
                  try {
                    viewModel.commands.archiveResearch(_research.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pesquisa arquivada com sucesso!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao arquivar: $e')),
                    );
                  }
                },
              ),
      MenuAction(
        label: 'Exportar',
        icon: Icons.download_outlined,
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          try {
            await viewModel.commands.exportResearchToExcel(_research.id);
            if (!mounted) return;
            messenger.showSnackBar(
              const SnackBar(content: Text('Planilha exportada com sucesso!')),
            );
          } catch (e) {
            if (!mounted) return;
            messenger.showSnackBar(
              SnackBar(content: Text('Erro ao exportar: $e')),
            );
          }
        },
      ),
      if (canCoordinate)
        MenuAction(
          label: 'Editar',
          icon: Icons.edit_outlined,
          onTap: () => unawaited(_editResearch()),
        ),
      if (isAdministrator)
        MenuAction(
          label: 'Excluir',
          icon: Icons.delete_outline,
          onTap: () => unawaited(deleteResearch()),
        ),
      MenuAction(label: 'Sair', icon: Icons.exit_to_app, onTap: () {}),
    ];

    return Scaffold(
      appBar: HeaderRoute(
        route: [_research.name],
        action: PopMenu(
          sections: [
            if (addItems.isNotEmpty)
              MenuSection(title: 'Adicionar', items: addItems),
            MenuSection(title: 'Gerenciar', items: manageItems),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 1),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              InfoCard(
                props: [
                  'Nome',
                  'Data',
                  'Intervalo',
                  ...researchAttributes.map((attribute) => "Atributo"),
                ],
                info: [
                  _research.name,
                  dateFormat(_research.date),
                  _research.interval,
                  ...researchAttributes.map((attribute) => attribute.value),
                ],
              ),
              const SizedBox(height: 20),
              Watch((context) {
                final state = viewModel.researchState;
                final isLoading = viewModel
                    .commands
                    .getModelQuestsFromResearchCommand
                    .isExecuting
                    .value;
                final modelQuests = state.modelQuestsState.value;

                return CardCarousel(
                  title: 'Questionários Modelos',
                  cards: modelQuests
                      .map(
                        (modelQuest) => QuestCard(
                          title: modelQuest.name,

                          questions: modelQuest.questions.length.toString(),
                          onTap: () => context.pushNamed(
                            MedQuestRouteNames.modelquest,
                            extra: modelQuest,
                          ),
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.modelQuestsMessage.value ??
                              'Nenhum questionário encontrado.',
                        ),
                );
              }),
              Watch((context) {
                final state = viewModel.researchState;
                final isLoading =
                    viewModel.commands.getGroupsCommand.isExecuting.value;
                final groups = state.groupsState.value;

                return CardCarousel(
                  title: 'Grupos da pesquisa',
                  cards: groups
                      .map(
                        (group) => GroupCard(
                          title: group.name,
                          patients: group.patientCount.toString(),
                          onTap: () async {
                            await context.pushNamed(
                              MedQuestRouteNames.group,
                              extra: (research: _research, group: group),
                            );

                            if (mounted) {
                              unawaited(_loadGroups());
                              viewModel.commands.getScoreChartDataCommand
                                  .executeWith((
                                    researchId: widget.research.id,
                                  ));
                            }
                          },
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.groupsMessage.value ??
                              'Nenhum grupo encontrado.',
                        ),
                );
              }),
              const SizedBox(height: 10),
              Watch((context) {
                final state = viewModel.researchState;
                final isLoading =
                    viewModel.commands.getGroupsCommand.isExecuting.value;
                final groups = state.groupsState.value;

                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (groups.isEmpty) {
                  return const Text('Nenhum grupo encontrado.');
                }

                return Column(
                  children: groups.map((group) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Gráfico de Categorias: ${group.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          CategoryChart(
                            patients: group.patients,
                            availableAttributes: const [
                              {'key': 'sex', 'label': 'Sexo'},
                              {
                                'key': 'smokingLevel',
                                'label': 'Nível de Tabagismo',
                              },
                              {'key': 'ethnicity', 'label': 'Etnia'},
                              {
                                'key': 'educationLevel',
                                'label': 'Escolaridade',
                              },
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Evolução de Score x Período (Geral)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Watch((context) {
                      final state = viewModel.researchState;

                      final isLoading = viewModel
                          .commands
                          .getScoreChartDataCommand
                          .isExecuting
                          .value;

                      final chartDataMap = state.scoreChartDataState.value;

                      if (isLoading && chartDataMap.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (chartDataMap.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Nenhum dado de score disponível para esta pesquisa.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 400,
                        child: ScoreChart(groupChartDataMap: chartDataMap),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
