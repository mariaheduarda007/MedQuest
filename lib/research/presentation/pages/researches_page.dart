import 'package:flutter/material.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/controllers/research_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/di/injector.dart';
import 'package:medquest/core/theme/theme.dart';

class ResearchesPage extends StatefulWidget {
  const ResearchesPage({super.key});

  @override
  State<ResearchesPage> createState() => _ResearchesPageState();
}

class _ResearchesPageState extends State<ResearchesPage> {
  late final ResearchViewModel researchController;
  final Research research = Research(
    id: '1OtO6wCZiT9yljwWP2us',
    name: 'Pesquisa de Teste',
    date: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    researchController = injector.get<ResearchViewModel>();
    _createResearchForTest();
  }

  Future<void> _createResearchForTest() async {
    researchController.researchState.setResearch(null);
    researchController.researchState.clearMessage();
    await researchController.commands.unarchiveResearch(research.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Watch((context) {
            final state = researchController.researchState;
            final isCreating = researchController
                .commands
                .createResearchCommand
                .isExecuting
                .value;
            final createdResearch = state.state.value;

            if (isCreating) {
              return const CircularProgressIndicator();
            }

            if (createdResearch == null) {
              return Text(
                state.message.value ?? 'Não foi possível criar a pesquisa.',
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Pesquisa criada com sucesso.'),
                Text('ID: ${createdResearch.id}'),
                Text('Nome: ${createdResearch.name}'),
                Text('Data: ${createdResearch.date}'),
              ],
            );
          }),
        ),
      ),
    );
  }
}
