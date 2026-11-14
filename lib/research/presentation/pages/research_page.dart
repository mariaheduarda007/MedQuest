import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/group/presentation/controllers/group_viewmodel.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/group_card.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/research_pop_menu.dart';
import 'package:medquest/research/presentation/widgets/research_info_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ResearchPage extends StatefulWidget {
  const ResearchPage({super.key, required this.research});

  final Research research;

  @override
  State<ResearchPage> createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  late final GroupViewModel groupController;
  late final ModelQuestViewModel modelQuestController;

  @override
  void initState() {
    super.initState();
    groupController = injector.get<GroupViewModel>();
    modelQuestController = injector.get<ModelQuestViewModel>();
    groupController.groupState.setGroups([]);
    groupController.groupState.clearMessage();
    unawaited(_loadGroups());
    unawaited(_loadModelQuests());
  }

  Future<void> _loadGroups() async {
    await groupController.commands.getGroups(widget.research.id);
  }

  Future<void> _loadModelQuests() async {
    await modelQuestController.commands.getAllModelQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.research.name],
        action: ResearchPopupMenu(
          sections: [
            MenuSection(
              title: 'Adicionar',
              items: [
                MenuAction(
                  label: 'Grupo',
                  icon: Icons.group_add_outlined,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Questionário',
                  icon: Icons.assignment_add,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Pesquisador',
                  icon: Icons.person_add_alt_1,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Coordenador',
                  icon: Icons.person_add,
                  onTap: () {},
                ),
              ],
            ),
            MenuSection(
              title: 'Gerenciar',
              items: [
                MenuAction(
                  label: 'Arquivar',
                  icon: Icons.archive_outlined,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Exportar',
                  icon: Icons.download_outlined,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Editar',
                  icon: Icons.edit_outlined,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Sair',
                  icon: Icons.exit_to_app,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenuBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ResearchInfo(
                props: ['Nome', 'Data'],
                info: [widget.research.name, dateFormat(widget.research.date)],
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
                final state = groupController.groupState;
                final isLoading =
                    groupController.commands.getGroupsCommand.isExecuting.value;
                final groups = state.groupsState.value ?? const [];

                return CardCarousel(
                  title: 'Grupos da pesquisa',
                  cards: groups
                      .map(
                        (group) => GroupCard(
                          title: group.name,
                          patients: group.patientCount.toString(),
                          onTap: () {},
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(state.message.value ?? 'Nenhum grupo encontrado.'),
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
