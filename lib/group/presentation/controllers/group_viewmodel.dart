import '../commands/group_commands.dart';
import 'group_commands_viewmodel.dart';
import 'group_state_viewmodel.dart';

class GroupViewModel {
  late final GroupStateViewModel _state;

  /// Getter público para acessar o estado de Group
  GroupStateViewModel get groupState => _state;

  /// dispara os commands e effects e observa as mudanças de estado
  late final GroupCommandsViewModel commands;

  /// Construtor que inicializa a VieModel principal que será consumida na UI
  /// injeta a dependência do Facade dos casos de uso de Patient

  // PatientViewModel(IPatientFacadeUseCases facade) {
  //   _state = PatientStateViewModel();

  //   commands = PatientCommandsViewModel(
  //     state: _state,
  //     createPatientCommand: CreatePatientCommand(facade),
  //     updatePatientCommand: UpdatePatientCommand(facade),
  //     getPatientCommand: GetPatientCommand(facade),
  //     deletePatientCommand: DeletePatientCommand(facade),
  //   );
  // }


//mudei o construtor para que ele nao dependa de nada, e coloquei stateviewmodel na di
  GroupViewModel({
    required GroupStateViewModel state,
    required this.commands,
  }) : _state = state;


  // --- Comandos expostos ---
  CreateGroupCommand get saveGroupCommand => commands.createGroupCommand;
  GetGroupCommand get getGroupCommand => commands.getGroupCommand;
  GetGroupsCommand get getGroupsCommand => commands.getGroupsCommand;
  DeleteGroupCommand get deleteGroupCommand =>
      commands.deleteGroupCommand;

}
