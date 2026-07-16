import 'user_commands_viewmodel.dart';
import 'user_state_viewmodel.dart';
import 'package:medquest/userContext/user/presentation/commands/user_commands.dart';
import 'package:medquest/userContext/user/domain/facades/i_user_facade_usecases.dart';

class UserViewModel {
  late final UserStateViewModel _state;

  /// Getter público para acessar o estado de User
  UserStateViewModel get userState => _state;

  /// dispara os commands e effects e observa as mudanças de estado
  late final UserCommandsViewmodel commands;

  /// Construtor que inicializa a VieModel principal
  /// que será consumida na UI
  /// injeta a dependência do Facade dos casos de uso de User
  /// o facade sera consumido pelos commands

  UserViewModel(IUserFacadeUseCases facade) {
    _state = UserStateViewModel();
    // dispara os commands e effects
    commands = UserCommandsViewmodel(
      state: _state,
      saveUserCommand: SaveUserCommand(facade),
      updateUserCommand: UpdateUserCommand(facade),
      getUserCommand: GetUserCommand(facade),
      deleteUserCommand: DeleteUserCommand(facade),
    );
  }
  // --- Comandos expostos ---
  GetUserCommand get getUserCommand => commands.getUserCommand;
  SaveUserCommand get saveUserCommand => commands.saveUserCommand;
  DeleteUserCommand get deleteUserCommand => commands.deleteUserCommand;
  UpdateUserCommand get updateUserCommand => commands.updateUserCommand;
}
