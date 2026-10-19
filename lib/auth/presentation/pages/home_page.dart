import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/data/services/remote/i_userRole_remote_service.dart';
// import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/injector.dart';
// import 'package:medquest/core/theme/theme.dart';
import '../../domain/models/auth_entities.dart';
import '../controllers/auth_session_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/research_card.dart';
import 'package:medquest/research/presentation/widgets/app_search_bar.dart';
import 'package:medquest/research/presentation/controllers/research_viewmodel.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.session});

  final String title;
  final AuthSession session;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();
  late final AuthViewModel authController;
  late final ResearchViewModel researchController;
  late final ModelQuestViewModel modelQuestController;
  bool canCreateResearch = false;
  bool isLoadingPermissions = true;

  @override
  void initState() {
    authController = injector.get<AuthViewModel>();
    researchController = injector.get<ResearchViewModel>();
    modelQuestController = injector.get<ModelQuestViewModel>();
    super.initState();
    _loadUserPermissions();
    unawaited(_loadResearches());
    unawaited(_loadModelQuests());
  }

  Future<void> _loadResearches() async {
    await researchController.commands.getResearches(const []);
  }

  Future<void> _loadModelQuests() async {
    await modelQuestController.commands.getAllModelQuests();
  }

  Future<void> _loadUserPermissions() async {
    try {
      final userRoleService = injector.get<IUserRoleRemoteService>();
      final permissionService = injector.get<PermissionCacheService>();

      final result = await userRoleService.getUserRolesByUserId(
        widget.session.user.uid,
      );

      if (result.isSuccess) {
        final roles = result.successValueOrNull ?? [];

        bool hasPermissionToCreate = false;

        for (var userRole in roles) {
          if (permissionService.hasPermission(
            userRole.permissionId,
            'createResearch',
          )) {
            hasPermissionToCreate = true;
            break;
          }
        }

        setState(() {
          canCreateResearch = hasPermissionToCreate;
          isLoadingPermissions = false;
        });
      } else {
        setState(() => isLoadingPermissions = false);
      }
    } catch (e) {
      setState(() => isLoadingPermissions = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      bottomNavigationBar: const BottomMenuBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              AppSearchBar(
                controller: searchController,
                hintText: 'Buscar pesquisas...',
              ),
              const SizedBox(height: 20),
              Watch((context) {
                final state = modelQuestController.modelQuestState;
                final isLoading = modelQuestController
                    .commands
                    .getAllModelQuestsCommand
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
                          onTap: () {},
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.message.value ??
                              'Nenhum questionário encontrado.',
                        ),
                );
              }),
              Watch((context) {
                final state = researchController.researchState;
                final isLoading = researchController
                    .commands
                    .getResearchesCommand
                    .isExecuting
                    .value;
                final researches = state.researchesState.value ?? const [];
                final recentResearches = List.of(researches)
                  ..sort((a, b) => b.date.compareTo(a.date));

                return CardCarousel(
                  title: 'Pesquisas Recentes',
                  cards: recentResearches
                      .map(
                        (research) => ResearchCard(
                          title: research.name,
                          date: DateFormat('dd/MM/yy').format(research.date),
                          questionnaires: research.quests.length,
                          onTap: () {},
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.message.value ?? 'Nenhuma pesquisa encontrada.',
                        ),
                );
              }),
              const SizedBox(height: 10),
              if (!isLoadingPermissions) ...[
                if (canCreateResearch) ...[
                  ActionButton(
                    text: 'Nova Pesquisa',
                    onPressed: () {},
                    size: ActionButtonSize.xl,
                    variant: ActionButtonVariant.outlined,
                  ),
                  const SizedBox(height: 10),
                ],
              ],
              ActionButton(
                text: 'Novo Questionário',
                onPressed: () {},
                size: ActionButtonSize.xl,
                variant: ActionButtonVariant.filled,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
