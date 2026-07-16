import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/command.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:medquest/userContext/user/domain/facades/i_user_facade_usecases.dart';


final class SaveUserCommand extends ParameterizedCommand<void, Failure, UserParams> {
  final IUserFacadeUseCases _userFacadeUseCases;

  SaveUserCommand(this._userFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar usuario.'));
    }
    return await _userFacadeUseCases.saveUser(parameter!);
  }
}

final class UpdateUserCommand
    extends ParameterizedCommand<void, Failure, UserParams> {
  final IUserFacadeUseCases _userFacadeUseCases;

  UpdateUserCommand(this._userFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar usuario.'));
    }
    return await _userFacadeUseCases.updateUser(parameter!);
  }
}

final class GetUserCommand
    extends ParameterizedCommand<User, Failure, NoParams> {
  final IUserFacadeUseCases _userFacadeUseCases;

  GetUserCommand(this._userFacadeUseCases);

  @override
  Future<UserResult> execute() async {
    return await _userFacadeUseCases.getUser(());
  }
}

final class DeleteUserCommand
    extends ParameterizedCommand<void, Failure, NoParams> {
  final IUserFacadeUseCases _userFacadeUseCases;

  DeleteUserCommand(this._userFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    return await _userFacadeUseCases.deleteUser(());
  }
}
