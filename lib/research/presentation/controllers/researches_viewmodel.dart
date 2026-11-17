import 'package:medquest/research/presentation/commands/research_commands.dart';

import 'researches_commands_viewmodel.dart';
import 'researches_state_viewmodel.dart';

class ResearchesViewModel {
  final ResearchesStateViewModel researchesState;
  final ResearchesCommandsViewModel commands;

  ResearchesViewModel({required this.researchesState, required this.commands});

  GetResearchesCommand get getResearchesCommand =>
      commands.getResearchesCommand;
}
