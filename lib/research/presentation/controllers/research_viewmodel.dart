import '../commands/research_commands.dart';
import 'research_commands_viewmodel.dart';
import 'research_state_viewmodel.dart';

class ResearchViewModel {
  late final ResearchStateViewModel _state;

  /// Getter público para acessar o estado de Research
  ResearchStateViewModel get researchState => _state;

  /// dispara os commands e effects e observa as mudanças de estado
  late final ResearchCommandsViewModel commands;

  /// Construtor que inicializa a VieModel principal que será consumida na UI
  /// injeta a dependência do Facade dos casos de uso de Research

      // ResearchViewModel(IResearchFacadeUseCases facade) {
      //   _state = ResearchStateViewModel();

      //   commands = ResearchCommandsViewModel(
      //     state: _state,
      //     createResearchCommand: CreateResearchCommand(facade),
      //     updateResearchCommand: UpdateResearchCommand(facade),
      //     getResearchCommand: GetResearchCommand(facade),
      //     deleteResearchCommand: DeleteResearchCommand(facade),
      //   );
      // }

  //mudei o construtor para que ele nao dependa de nada, e coloquei stateviewmodel no DI

  ResearchViewModel({
    required ResearchStateViewModel state, //injetada pelo DI
    required this.commands, 
  }) : _state = state;

  // --- Comandos expostos ---
  CreateResearchCommand get createResearchCommand => commands.createResearchCommand;
  GetResearchCommand get getResearchCommand => commands.getResearchCommand;
  GetResearchesCommand get getResearchesCommand => commands.getResearchesCommand;
  UpdateResearchCommand get updateResearchCommand =>
      commands.updateResearchCommand;
  DeleteResearchCommand get deleteResearchCommand =>
      commands.deleteResearchCommand;
  ArchiveResearchCommand get archiveResearchCommand => commands.archiveResearchCommand;
  UnarchiveResearchCommand get unarchiveResearchCommand => commands.unarchiveResearchCommand;
}
