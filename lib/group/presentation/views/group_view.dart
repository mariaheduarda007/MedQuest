import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medquest/core/functions/ui_functions.dart';
import 'package:medquest/core/routes/medquest_routes.dart';
import 'package:medquest/core/theme/theme.dart';
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
  late final GroupViewModel groupController;
  PatientFilterType selectedFilter = PatientFilterType.all;

  @override
  void initState() {
    super.initState();
    groupController = injector.get<GroupViewModel>();
    groupController.groupState.setGroup(widget.group);
    groupController.groupState.setPatients([]);
    groupController.groupState.clearPatientsMessage();
    groupController.groupState.clearMessage();
    unawaited(_loadPatients());
  }

  Future<void> _loadPatients() async {
    await groupController.commands.getPatients(
      widget.research.id,
      widget.group.id,
    );
  }

//   Future<void> _createPatient() async {
//     Patient patient = final patient = Patient(
//   id: 'patient_test',
//   name: 'Paciente Teste',
//   treatmentStartAge: 25,
//   sex: 'Feminino',
//   income: 2500.0,
//   smokingLevel: SmokingLevel.never,
//   elitism: 'Não',
//   ethnicity: 'Não informado',
//   birthPlacement: 'Hospital',
//   birthDate: DateTime(2000, 1, 1),
//   weight: 65.0,
//   height: 1.65,
//   occupation: 'Estudante',
//   educationLevel: 'Ensino Superior',
//   drugs: [],
//   comorbidities: [],
//   participationStatus: true,
//   exitReason: null,
//   researchAttributes: {},
// );
//     await groupController.commands.createPatient(
//       widget.group.id,
//       widget.research.id,
//     );
//   }

  @override
  Widget build(BuildContext context) {
    final state = groupController.groupState;
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
                  onTap: () {},
                ),
              ],
            ),
            MenuSection(
              title: 'Gerenciar',
              items: [
                MenuAction(
                  label: 'Excluir Grupo',
                  icon: Icons.delete,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenuBar(),
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

                final isLoading = groupController
                    .commands
                    .getPatientsCommand
                    .isExecuting
                    .value;

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
