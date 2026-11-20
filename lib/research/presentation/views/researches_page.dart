import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/research/presentation/controllers/researches_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_title.dart';
import 'package:medquest/research/presentation/widgets/list_item.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/presentation/controllers/userRole_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ResearchesView extends StatefulWidget {
  const ResearchesView({super.key});

  @override
  State<ResearchesView> createState() => _ResearchesPageState();
}

class _ResearchesPageState extends State<ResearchesView> {
  late final AuthViewModel _authViewModel;
  late final UserRoleViewModel _userRoleViewModel;
  late final ResearchesViewModel _viewModel;
  late final PermissionCacheService _permissionService;
  Map<String, String> _roleNameByResearch = {};
  Set<String> _researchIdsWithRole = {};
  bool _isLoading = true;
  String? _loadError;
  String? _permissionLoadError;

  @override
  void initState() {
    super.initState();
    _authViewModel = injector.get<AuthViewModel>();
    _userRoleViewModel = injector.get<UserRoleViewModel>();
    _viewModel = injector.get<ResearchesViewModel>();
    _permissionService = injector.get<PermissionCacheService>();
    unawaited(_loadResearches());
  }

  Future<void> _loadResearches() async {
    _viewModel.researchesState.setResearches([]);
    _viewModel.researchesState.clearMessage();
    _roleNameByResearch = {};
    _researchIdsWithRole = {};

    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
        _permissionLoadError = null;
      });
    }

    final userId = _authViewModel.session.session.value?.user.uid;
    if (userId == null) {
      _viewModel.researchesState.setResearches([]);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Não foi possível identificar o usuário autenticado.';
        });
      }
      return;
    }

    final userRoleState = _userRoleViewModel.userRoleState;
    userRoleState.setUserRoles([]);
    userRoleState.clearMessage();
    await _userRoleViewModel.commands.fetchUserRoles(userId);

    final rolesError = userRoleState.message.value;
    if (rolesError != null) {
      _viewModel.researchesState.setResearches([]);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = rolesError;
        });
      }
      return;
    }

    try {
      await _permissionService.loadPermissions();
    } catch (error) {
      _permissionLoadError = 'Não foi possível carregar o papel: $error';
    }

    final permissions = _permissionService.allPermissions;
    final userRoles = userRoleState.state.value
        .where((role) => role.userId == userId)
        .toList();
    final researchIds = userRoles
        .map((role) => role.researchId)
        .whereType<String>()
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    _researchIdsWithRole = researchIds.toSet();
    final roleNameByResearch = <String, String>{};
    for (final role in userRoles) {
      final researchId = role.researchId?.trim();
      if (researchId == null ||
          researchId.isEmpty ||
          _permissionLoadError != null) {
        continue;
      }

      final roleName = permissions?[role.permissionId]?['roleName'];
      roleNameByResearch[researchId] =
          roleName is String && roleName.trim().isNotEmpty
          ? roleName.trim()
          : 'Papel não identificado';
    }
    _roleNameByResearch = roleNameByResearch;

    if (researchIds.isEmpty) {
      _viewModel.researchesState.setResearches([]);
      _viewModel.researchesState.clearMessage();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Nenhuma pesquisa vinculada aos seus papéis.';
        });
      }
      return;
    }

    _viewModel.researchesState.clearMessage();
    await _viewModel.commands.getResearches(researchesId: researchIds);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _loadError = _viewModel.researchesState.message.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: HeaderTitle(
                title: 'Suas Pesquisas',
                buttonTitle: '+ Pesquisa',
                onPressed: _loadResearches,
              ),
            ),
            Expanded(
              child: Watch((context) {
                final state = _viewModel.researchesState;
                final isLoading =
                    _isLoading ||
                    _viewModel.getResearchesCommand.isExecuting.value;
                final researches =
                    List.of(state.researchesState.value)
                        .where(
                          (research) =>
                              _researchIdsWithRole.contains(research.id) &&
                              !research.archived,
                        )
                        .toList()
                      ..sort((a, b) => b.date.compareTo(a.date));

                if (isLoading && researches.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (researches.isEmpty) {
                  return Center(
                    child: Text(
                      _loadError ??
                          state.message.value ??
                          'Nenhuma pesquisa encontrada.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadResearches,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: researches.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final research = researches[index];
                      final roleName =
                          _permissionLoadError ??
                          _roleNameByResearch[research.id] ??
                          'Sem papel nesta pesquisa';

                      return ListItem(
                        icon: Icons.science_outlined,
                        title: research.name,
                        subtitle: roleName,
                        onTap: () {
                          context.pushNamed(
                            MedQuestRouteNames.research,
                            extra: research,
                          );
                        },
                      );
                    },
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: HeaderTitle(title: 'Pesquisas Arquivadas'),
            ),
            Expanded(
              child: Watch((context) {
                final state = _viewModel.researchesState;
                final isLoading =
                    _isLoading ||
                    _viewModel.getResearchesCommand.isExecuting.value;
                final researches =
                    List.of(state.researchesState.value)
                        .where(
                          (research) =>
                              _researchIdsWithRole.contains(research.id) &&
                              research.archived,
                        )
                        .toList()
                      ..sort((a, b) => b.date.compareTo(a.date));

                if (isLoading && researches.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (researches.isEmpty) {
                  return Center(
                    child: Text(
                      _loadError ??
                          state.message.value ??
                          'Nenhuma pesquisa encontrada.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadResearches,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: researches.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final research = researches[index];
                      final roleName =
                          _permissionLoadError ??
                          _roleNameByResearch[research.id] ??
                          'Sem papel nesta pesquisa';

                      return ListItem(
                        icon: Icons.science_outlined,
                        title: research.name,
                        subtitle: roleName,
                        onTap: () {
                          context.pushNamed(
                            MedQuestRouteNames.research,
                            extra: research,
                          );
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
