import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/patient/presentation/controllers/patient_viewmodel.dart';
import 'package:medquest/patient/presentation/widgets/info_tags_card.dart';
import 'package:medquest/patient/presentation/widgets/edit_patient_dialog.dart';
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
  late final PatientViewModel viewModel;
  late Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    viewModel = injector.get<PatientViewModel>();
    viewModel.patientState.setPatient(widget.patient);
    viewModel.patientState.setModelQuests([]);
    viewModel.patientState.clearModelQuestsMessage();
    viewModel.patientState.setAnsweredQuests([]);
    viewModel.patientState.clearAnsweredQuestsMessage();
    unawaited(_loadAnsweredQuests());
    unawaited(_loadModelQuests());
  }

  Future<void> _loadModelQuests() async {
    await viewModel.commands.getModelQuestsFromResearch(widget.research.id);
  }

  Future<void> _loadAnsweredQuests() async {
    await viewModel.commands.getAnsweredQuests(
      widget.group.id,
      _patient,
      widget.research.id,
    );
  }

  Future<void> editPatient() async {
    final updatedPatient = await showDialog<Patient>(
      context: context,
      builder: (_) => EditPatientDialog(
        patient: _patient,
        researchAttributes: widget.research.researchAttributes,
      ),
    );
    if (updatedPatient == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Salvando paciente...')),
    );

    final result = await viewModel.commands.updatePatient(
      updatedPatient,
      widget.research.id,
      widget.group.id,
    );
    if (!mounted) return;

    result.fold(
      onSuccess: (savedPatient) {
        setState(() => _patient = savedPatient);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Paciente atualizado com sucesso!')),
          );
      },
      onFailure: (error) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('Erro ao atualizar paciente: ${error.msg}')),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.research.name, widget.group.name, _patient.name],
        action: PopMenu(
          sections: [
            MenuSection(
              title: 'Gerenciar',
              items: [
                MenuAction(
                  label: 'Editar Info',
                  icon: Icons.edit_attributes,
                  onTap: () => unawaited(editPatient()),
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
                  _patient.name,
                  '${_patient.treatmentStartAge.toString()} anos',
                  '${calculateAge(_patient.birthDate).toString()} anos',
                  _patient.sex,
                  _patient.educationLevel,
                  _patient.elitism,
                  _patient.ethnicity,
                  _patient.height.toString(),
                  _patient.income.toString(),
                  _patient.occupation,
                  _patient.smokingLevel.displayName,
                  '${_patient.weight.toString()} kg',
                  _patient.participationStatus ? 'Ativo' : 'Inativo',
                ],
              ),
              if (_patient.comorbidities.isNotEmpty) ...[
                const SizedBox(height: 20),

                InfoTagsCard(
                  title: 'Comorbidades',
                  values: _patient.comorbidities,
                ),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 20),

              Watch((context) {
                final state = viewModel.patientState;
                final isLoading = viewModel
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
                final state = viewModel.patientState;
                final isLoading = viewModel
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
