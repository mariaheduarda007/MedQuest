import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/group_card.dart';
import 'package:medquest/research/presentation/controllers/research_viewmodel.dart';
import 'package:medquest/research/presentation/widgets/pop_menu.dart';
import 'package:medquest/research/presentation/widgets/info_card.dart';
import 'package:medquest/research/presentation/widgets/score_chart.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/research/presentation/widgets/category_chart.dart';

class ResearchView extends StatefulWidget {
  const ResearchView({super.key, required this.research});

  final Research research;

  @override
  State<ResearchView> createState() => _ResearchViewState();
}

class _ResearchViewState extends State<ResearchView> {
  late final ResearchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = injector.get<ResearchViewModel>();
    viewModel.researchState.setGroups([]);
    viewModel.researchState.setModelQuests([]);
    viewModel.researchState.clearGroupsMessage();
    viewModel.researchState.clearModelQuestsMessage();
    viewModel.commands.getScoreChartDataCommand.executeWith((
      researchId: widget.research.id,
    ));
    unawaited(_loadGroups());
    unawaited(_loadModelQuests());
  }

  Future<void> _loadGroups() async {
    await viewModel.commands.getGroups(widget.research.id);
  }

  Future<void> _loadModelQuests() async {
    await viewModel.commands.getModelQuestsFromResearch(widget.research.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.research.name],
        action: PopMenu(
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
                widget.research.archived
                    ? MenuAction(
                        label: 'Arquivar',
                        icon: Icons.archive_outlined,
                        onTap: () {
                          try {
                            viewModel.commands.archiveResearch(
                              widget.research.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Pesquisa arquivada com sucesso!',
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao arquivar: $e')),
                            );
                          }
                        },
                      )
                    : MenuAction(
                        label: 'Desarquivar',
                        icon: Icons.archive_outlined,
                        onTap: () {
                          try {
                            viewModel.commands.unarchiveResearch(
                              widget.research.id,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Pesquisa desarquivada com sucesso!',
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao desarquivar: $e'),
                              ),
                            );
                          }
                        },
                      ),
                MenuAction(
                  label: 'Exportar',
                  icon: Icons.download_outlined,
                  onTap: () async {
                    try {
                      await viewModel.commands.exportResearchToExcel(
                        widget.research.id,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Planilha exportada com sucesso!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao exportar: $e')),
                      );
                    }
                  },
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
              InfoCard(
                props: ['Nome', 'Data'],
                info: [widget.research.name, dateFormat(widget.research.date)],
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
                          onTap: () {},
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
                          onTap: () {
                            context.pushNamed(
                              MedQuestRouteNames.group,
                              extra: (research: widget.research, group: group),
                            );
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
