import 'user_commands_viewmodel.dart';
import 'user_state_viewmodel.dart';
import 'package:medquest/userContext/user/presentation/commands/user_commands.dart';
import 'package:medquest/userContext/user/domain/facades/i_user_facade_usecases.dart';

class UserViewModel {
  late final UserStateViewModel _state;

  UserStateViewModel get userState => _state;

  late final UserCommandsViewmodel commands;

  UserViewModel(IUserFacadeUseCases facade) {
    _state = UserStateViewModel();
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
