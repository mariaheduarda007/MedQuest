import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/patient/presentation/controllers/patient_viewmodel.dart';
import 'package:medquest/patient/presentation/widgets/info_tags_card.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/pop_menu.dart';
import 'package:medquest/research/presentation/widgets/info_card.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PatientView extends StatefulWidget {
  const PatientView({
    super.key,
    required this.research,
    required this.group,
    required this.patient,
  });

  final Research research;
  final Group group;
  final Patient patient;

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  late final PatientViewModel patientController;

  @override
  void initState() {
    super.initState();
    patientController = injector.get<PatientViewModel>();
    patientController.patientState.setPatient(widget.patient);
    patientController.patientState.setModelQuests([]);
    patientController.patientState.clearModelQuestsMessage();
    patientController.patientState.setAnsweredQuests([]);
    patientController.patientState.clearAnsweredQuestsMessage();
    unawaited(_loadAnsweredQuests());
    unawaited(_loadModelQuests());
  }

  Future<void> _loadModelQuests() async {
    await patientController.commands.getModelQuestsFromResearch(
      widget.research.id,
    );
  }

  Future<void> _loadAnsweredQuests() async {
    await patientController.commands.getAnsweredQuests(
      widget.group.id,
      widget.patient,
      widget.research.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.research.name, widget.group.name, widget.patient.name],
        action: PopMenu(
          sections: [
            MenuSection(
              title: 'Gerenciar',
              items: [
                MenuAction(
                  label: 'Editar Info',
                  icon: Icons.edit_attributes,
                  onTap: () {},
                ),
                MenuAction(
                  label: 'Inativar',
                  icon: Icons.archive,
                  onTap: () {
                    context.pop();
                  },
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
                props: [
                  'Nome',
                  'Idade Inicial',
                  'Idade Atual',
                  'Sexo',
                  'Nível Escolar',
                  'Classe Social',
                  'Etnia',
                  'Altura',
                  'Renda',
                  'Profissão',
                  'Nível Fumo',
                  'Peso',
                  'Participação',
                ],
                info: [
                  widget.patient.name,
                  '${widget.patient.treatmentStartAge.toString()} anos',
                  '${calculateAge(widget.patient.birthDate).toString()} anos',
                  widget.patient.sex,
                  widget.patient.educationLevel,
                  widget.patient.elitism,
                  widget.patient.ethnicity,
                  widget.patient.height.toString(),
                  widget.patient.income.toString(),
                  widget.patient.occupation,
                  widget.patient.smokingLevel.displayName,
                  '${widget.patient.weight.toString()} kg',
                  widget.patient.participationStatus ? 'Ativo' : 'Inativo',
                ],
              ),
              if (widget.patient.comorbidities.isNotEmpty) ...[
                const SizedBox(height: 20),

                InfoTagsCard(
                  title: 'Comorbidades',
                  values: widget.patient.comorbidities,
                ),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 20),

              Watch((context) {
                final state = patientController.patientState;
                final isLoading = patientController
                    .commands
                    .getModelQuestsFromResearchCommand
                    .isExecuting
                    .value;
                final modelQuests = state.modelQuestsState.value;

                return CardCarousel(
                  title: 'Aplicar Questionários',
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
                final state = patientController.patientState;
                final isLoading = patientController
                    .commands
                    .getAnsweredQuestsCommand
                    .isExecuting
                    .value;
                final answeredQuests = state.answeredQuestsState.value;

                return CardCarousel(
                  title: 'Histórico',
                  cards: answeredQuests
                      .map(
                        (answeredQuest) => QuestCard(
                          title: answeredQuest.id,
                          questions: answeredQuest.questions.length.toString(),
                          onTap: () {},
                        ),
                      )
                      .toList(),
                  emptyContent: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          state.answeredQuestMessage.value ??
                              'Nenhum questionário respondido encontrado.',
                        ),
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
