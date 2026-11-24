import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';
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
  final searchQuery = signal('');

  @override
  void initState() {
    super.initState();
    homeController = injector.get<HomeViewModel>();
    unawaited(homeController.commands.loadHome(widget.session.user.uid));
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateTo(String routeName, {Object? extra}) async {
    await context.pushNamed(routeName, extra: extra);
    searchController.clear();
    searchQuery.value = '';
    await homeController.commands.loadHome(widget.session.user.uid);
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

                final query = searchQuery.value.trim().toLowerCase();

                final filteredModelQuests = modelQuests.where((modelQuest) {
                  return modelQuest.name.toLowerCase().contains(query);
                }).toList();

                final carouselTitle = query.isNotEmpty
                    ? 'Modelos Encontrados'
                    : 'Questionários Modelos';

                return CardCarousel(
                  title: carouselTitle,
                  cards: filteredModelQuests
                      .map(
                        (modelQuest) => QuestCard(
                          title: modelQuest.name,
                          questions: modelQuest.questions.length.toString(),

                          onTap: () => _navigateTo(
                            MedQuestRouteNames.modelquest,
                            extra: modelQuest,
                          ),
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          query.isNotEmpty
                              ? 'Nenhum modelo encontrado para "$query".'
                              : (state.modelQuestsMessage.value ??
                                    'Nenhum questionário encontrado.'),
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

                final query = searchQuery.value.trim().toLowerCase();

                final filteredResearches = researches.where((research) {
                  return research.name.toLowerCase().contains(query);
                }).toList();

                final sortedResearches = List.of(filteredResearches)
                  ..sort((a, b) => b.date.compareTo(a.date));

                final carouselTitle = query.isNotEmpty
                    ? 'Pesquisas Encontradas'
                    : 'Pesquisas Recentes';

                return CardCarousel(
                  title: carouselTitle,
                  cards: sortedResearches
                      .map(
                        (research) => ResearchCard(
                          title: research.name,
                          date: DateFormat('dd/MM/yy').format(research.date),
                          questionnaires: research.quests.length,
                          onTap: () => _navigateTo(
                            MedQuestRouteNames.research,
                            extra: research,
                          ),
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          query.isNotEmpty
                              ? 'Nenhuma pesquisa encontrada para "$query".'
                              : (state.researchesMessage.value ??
                                    'Nenhuma pesquisa encontrada.'),
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
                onPressed: () =>
                    _navigateTo(MedQuestRouteNames.createModelquest),
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
