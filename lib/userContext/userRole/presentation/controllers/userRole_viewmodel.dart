import 'userRole_commands_viewmodel.dart';
import 'userRole_state_viewmodel.dart';
import 'package:medquest/userContext/userRole/presentation/commands/userRole_commands.dart';
import 'package:medquest/userContext/userRole/domain/facades/i_userRole_facade_usecases.dart';

class UserRoleViewModel {
  late final UserRoleStateViewModel _state;

  UserRoleStateViewModel get userRoleState => _state;

  late final UserRoleCommandsViewmodel commands;

  UserRoleViewModel(IUserRoleFacadeUseCases facade) {
    _state = UserRoleStateViewModel();
    commands = UserRoleCommandsViewmodel(
      state: _state,
      getUserRolesCommand: GetUserRolesByUserIdCommand(facade),
      createUserRoleCommand: CreateUserRoleCommand(facade),
      updateUserRoleCommand: UpdateUserRoleCommand(facade),
      deleteUserRoleCommand: DeleteUserRoleCommand(facade),
      getAllUserRolesCommand: GetAllUserRolesCommand(facade),
    );
  }

  // --- Comandos expostos ---
  GetUserRolesByUserIdCommand get getUserRolesCommand => commands.getUserRolesCommand;
  CreateUserRoleCommand get createUserRoleCommand => commands.createUserRoleCommand;
  UpdateUserRoleCommand get updateUserRoleCommand => commands.updateUserRoleCommand;
  DeleteUserRoleCommand get deleteUserRoleCommand => commands.deleteUserRoleCommand;
  GetAllUserRolesCommand get getAllUserRolesCommand => commands.getAllUserRolesCommand;
}