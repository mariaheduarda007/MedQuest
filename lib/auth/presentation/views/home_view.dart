import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/answeredquest/data/service/answeredquest_firestore_impl.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/core/di/injector.dart';
import '../../domain/models/auth_entities.dart';
import '../controllers/home_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/research_card.dart';
import 'package:medquest/research/presentation/widgets/app_search_bar.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.session});

  final String title;
  final AuthSession session;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final HomeViewModel homeController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeController = injector.get<HomeViewModel>();
    unawaited(homeController.commands.loadHome(widget.session.user.uid));
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
                final state = homeController.homeState;
                final isLoading =
                    homeController.getAllModelQuestsCommand.isExecuting.value;
                final modelQuests = state.modelQuestsState.value;

                return CardCarousel(
                  title: 'Questionários Modelos',
                  cards: modelQuests
                      .map(
                        (modelQuest) => QuestCard(
                          title: modelQuest.name,
                          questions: modelQuest.questions.length.toString(),
                          onTap: () {
                            context.pushNamed(MedQuestRouteNames.modelquest, extra: modelQuest);
                          },
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
                final state = homeController.homeState;
                final isLoading = homeController
                    .commands
                    .getResearchesCommand
                    .isExecuting
                    .value;
                final researches = state.researchesState.value;
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
                          onTap: () {
                            context.pushNamed(
                              MedQuestRouteNames.research,
                              extra: research,
                            );
                          },
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.researchesMessage.value ??
                              'Nenhuma pesquisa encontrada.',
                        ),
                );
              }),
              const SizedBox(height: 10),
              Watch((context) {
                final state = homeController.homeState;

                if (state.isLoadingPermissions.value) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    if (state.canCreateResearch.value) ...[
                      ActionButton(
                        text: 'Nova Pesquisa',
                        onPressed: () {},
                        size: ActionButtonSize.xl,
                        variant: ActionButtonVariant.outlined,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (state.permissionMessage.value case final message?)
                      Text(message, textAlign: TextAlign.center),
                  ],
                );
              }),
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
