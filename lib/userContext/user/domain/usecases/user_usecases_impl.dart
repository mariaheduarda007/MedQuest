import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/userContext/user/data/repositories/i_user_repository.dart';
import 'i_user_usecases.dart';

final class GetUserUseCaseImpl implements IGetUserUseCase {
  final IUserRepository _repository;

  GetUserUseCaseImpl({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<UserResult> call(NoParams params) async {
    return _repository.getUser();
  }
}

final class SaveUserUseCaseImpl implements ISaveUserUseCase {
  final IUserRepository _repository;

  SaveUserUseCaseImpl({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(UserParams params) async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    return _repository.saveUser(params.user);
  }
}

final class DeleteUserUseCaseImpl implements IDeleteUserUseCase {
  final IUserRepository _repository;

  DeleteUserUseCaseImpl({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(NoParams params) async {
    await Future.delayed(const Duration(seconds: 3));
    return _repository.deleteUser();
  }
}

final class UpdateUserUseCaseImpl implements IUpdateUserUseCase {
  final IUserRepository _repository;

  UpdateUserUseCaseImpl({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(UserParams params) async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    return _repository.updateUser(params.user);
  }
}
