import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/group/presentation/controllers/group_viewmodel.dart';
import 'package:medquest/group/presentation/widgets/patient_card.dart';
import 'package:medquest/group/presentation/widgets/patient_counter.dart';
import 'package:medquest/group/presentation/widgets/patient_filter.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/widgets/bottom_menu.dart';
import 'package:medquest/research/presentation/widgets/header_route.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/research/presentation/widgets/pop_menu.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key, required this.research, required this.group});

  final Research research;
  final Group group;

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  late final GroupViewModel viewModel;
  PatientFilterType selectedFilter = PatientFilterType.all;

  @override
  void initState() {
    super.initState();
    viewModel = injector.get<GroupViewModel>();
    viewModel.groupState.setGroup(widget.group);
    viewModel.groupState.setPatients([]);
    viewModel.groupState.clearPatientsMessage();
    viewModel.groupState.clearMessage();
    unawaited(_loadPatients());
  }

  Future<void> _loadPatients() async {
    await viewModel.commands.getPatients(widget.research.id, widget.group.id);
  }

  Future<void> deleteGroup() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Excluindo grupo...')));

    try {
      final result = await viewModel.commands.deleteGroup(
        researchId: widget.research.id,
        groupId: widget.group.id,
      );

      result.fold(
        onSuccess: (_) {
          unawaited(_loadPatients());
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Grupo excluído com sucesso!')),
            );
          if (mounted) context.pop(true);
        },
        onFailure: (error) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Erro ao excluir grupo: ${error.msg}')),
            );
        },
      );
    } catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Erro ao excluir grupo: $error')),
        );
    }
  }

  Future<void> createPatient() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Criando Paciente...')),
    );

    try {
      final patientNumber =
          (viewModel.groupState.patientsState.value?.length ?? 0) + 1;
      final researchAttributes = {
        for (final attribute in widget.research.researchAttributes.keys)
          attribute: 'Não informado',
      };
      final patient = Patient(
        name: 'Paciente $patientNumber',
        treatmentStartAge: 0,
        sex: 'Não informado',
        income: 0,
        smokingLevel: SmokingLevel.never,
        elitism: 'Não informado',
        ethnicity: 'Não informada',
        birthPlacement: 'Não informado',
        birthDate: DateTime.now(),
        weight: 0,
        height: 0,
        occupation: 'Não informado',
        educationLevel: 'Não informada',
        drugs: const [],
        comorbidities: const [],
        participationStatus: true,
        exitReason: null,
        researchAttributes: researchAttributes,
      );
      final result = await viewModel.commands.createPatient(
        patient: patient,
        researchId: widget.research.id,
        groupId: widget.group.id,
      );

      result.fold(
        onSuccess: (_) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Paciente criado com sucesso!')),
            );
        },
        onFailure: (error) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Erro ao criar paciente: ${error.msg}')),
            );
        },
      );
    } catch (error) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Erro ao criar paciente: $error')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = viewModel.groupState;
    // final patients = state.patientsState.value ?? [];
    return Scaffold(
      appBar: HeaderRoute(
        route: [widget.research.name, widget.group.name],
        action: PopMenu(
          sections: [
            MenuSection(
              title: 'Adicionar',
              items: [
                MenuAction(
                  label: 'Paciente',
                  icon: Icons.person_add,
                  onTap: () => unawaited(createPatient()),
                ),
              ],
            ),
            MenuSection(
              title: 'Gerenciar',
              items: [
                MenuAction(
                  label: 'Excluir Grupo',
                  icon: Icons.delete,
                  onTap: () {
                    unawaited(deleteGroup());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenuBar(initialIndex: 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Watch((context) {
                final patients = state.patientsState.value ?? [];
                final filteredPatients = patients.where((patient) {
                  final status = patient.participationStatus
                      .toString()
                      .trim()
                      .toLowerCase();

                  switch (selectedFilter) {
                    case PatientFilterType.all:
                      return true;
                    case PatientFilterType.active:
                      return status == 'true';
                    case PatientFilterType.inactive:
                      return status == 'false';
                  }
                }).toList();

                final isLoading =
                    viewModel.commands.getPatientsCommand.isExecuting.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientCounter(count: patients.length),

                    const SizedBox(height: 20),

                    PatientFilter(
                      selectedFilter: selectedFilter,
                      onChanged: (filter) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (patients.isEmpty)
                      const Center(child: Text('Nenhum paciente cadastrado'))
                    else if (filteredPatients.isEmpty)
                      const Center(
                        child: Text(
                          'Nenhum paciente encontrado para este filtro',
                        ),
                      )
                    else
                      Column(
                        children: filteredPatients.map((patient) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: PatientCard(
                              name: patient.name,
                              age: patient.treatmentStartAge,
                              activity: patient.participationStatus,
                              onTap: () => context.pushNamed(
                                MedQuestRouteNames.patient,
                                extra: (
                                  research: widget.research,
                                  group: widget.group,
                                  patient: patient,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
