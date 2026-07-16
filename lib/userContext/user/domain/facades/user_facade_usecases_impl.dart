import 'package:medquest/core/typedefs/type_defs.dart';
import 'i_user_facade_usecases.dart';
import '../usecases/i_user_usecases.dart';

/// implemantação do [IUserFacade] para
/// chamar os usecases relacionados a User

final class UserFacadeUsecasesImpl implements IUserFacadeUseCases {
  final IGetUserUseCase _getUserUseCase;
  final ISaveUserUseCase _saveUserUseCase;
  final IUpdateUserUseCase _updateUserUseCase;
  final IDeleteUserUseCase _deleteUserUseCase;

  UserFacadeUsecasesImpl({
    required IGetUserUseCase getUserUseCase,
    required ISaveUserUseCase saveUserUseCase,
    required IUpdateUserUseCase updateUserUseCase,
    required IDeleteUserUseCase deleteUserUseCase,
  }) : _getUserUseCase = getUserUseCase,
       _saveUserUseCase = saveUserUseCase,
       _updateUserUseCase = updateUserUseCase,
       _deleteUserUseCase = deleteUserUseCase;

  @override
  Future<UserResult> getUser(NoParams params) {
    return _getUserUseCase(params);
  }

  @override
  Future<VoidResult> saveUser(UserParams params) {
    return _saveUserUseCase(params);
  }

  @override
  Future<VoidResult> deleteUser(NoParams params) {
    return _deleteUserUseCase(params);
  }

  @override
  Future<VoidResult> updateUser(UserParams params) {
    return _updateUserUseCase(params);
  }
}
