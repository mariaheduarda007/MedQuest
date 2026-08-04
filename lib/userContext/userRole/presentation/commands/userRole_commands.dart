import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/command.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/userContext/userRole/domain/facades/i_userRole_facade_usecases.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';

final class GetUserRolesByUserIdCommand
    extends ParameterizedCommand<List<UserRoleModel>, Failure, UserRolesParams> {
  final IUserRoleFacadeUseCases _userRoleFacadeUseCases;

  GetUserRolesByUserIdCommand(this._userRoleFacadeUseCases);

  @override
  Future<UserRolesResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar as roles do usuario.'));
    }
    return await _userRoleFacadeUseCases.getUserRolesByUserId(parameter!);
  }
}

final class CreateUserRoleCommand
    extends ParameterizedCommand<void, Failure, CreateUserRoleParams> {
  final IUserRoleFacadeUseCases _userRoleFacadeUseCases;

  CreateUserRoleCommand(this._userRoleFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar a role do usuario.'));
    }
    return await _userRoleFacadeUseCases.createUserRole(parameter!);
  }
}

final class UpdateUserRoleCommand
    extends ParameterizedCommand<void, Failure, UpdateUserRoleParams> {
  final IUserRoleFacadeUseCases _userRoleFacadeUseCases;

  UpdateUserRoleCommand(this._userRoleFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar a role do usuario.'));
    }
    return await _userRoleFacadeUseCases.updateUserRole(parameter!);
  }
}

final class DeleteUserRoleCommand
    extends ParameterizedCommand<void, Failure, DeleteUserRoleParams> {
  final IUserRoleFacadeUseCases _userRoleFacadeUseCases;

  DeleteUserRoleCommand(this._userRoleFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para deletar a role do usuario.'));
    }
    return await _userRoleFacadeUseCases.deleteUserRole(parameter!);
  }
}

final class GetAllUserRolesCommand
    extends ParameterizedCommand<List<UserRoleModel>, Failure, NoParams> {
  final IUserRoleFacadeUseCases _userRoleFacadeUseCases;

  GetAllUserRolesCommand(this._userRoleFacadeUseCases);

  @override
  Future<AllUserRolesResult> execute() async {
    return await _userRoleFacadeUseCases.getAllUserRoles(());
  }
}