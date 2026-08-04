import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/userContext/userRole/data/repositories/i_userRole_repository.dart';
import 'i_userRole_usecases.dart';

final class GetUserRolesByUserIdUseCaseImpl implements IGetUserRolesByUserIdUseCase {
  final IUserRoleRepository _repository;

  GetUserRolesByUserIdUseCaseImpl({required IUserRoleRepository repository})
      : _repository = repository;

  @override
  Future<UserRolesResult> call(UserRolesParams params) async {
    return _repository.getUserRolesByUserId(params.userId);
  }
}

final class CreateUserRoleUseCaseImpl implements ICreateUserRoleUseCase {
  final IUserRoleRepository _repository;

  CreateUserRoleUseCaseImpl({required IUserRoleRepository repository})
      : _repository = repository;

  @override
  Future<VoidResult> call(CreateUserRoleParams params) async {
    return _repository.createUserRole(
      userId: params.userId,
      permissionId: params.permissionId,
      researchId: params.researchId,
    );
  }
}

final class UpdateUserRoleUseCaseImpl implements IUpdateUserRoleUseCase {
  final IUserRoleRepository _repository;

  UpdateUserRoleUseCaseImpl({required IUserRoleRepository repository})
      : _repository = repository;

  @override
  Future<VoidResult> call(UpdateUserRoleParams params) async {
    return _repository.updateUserRole(
      userRoleId: params.userRoleId,
      permissionId: params.permissionId,
      researchId: params.researchId,
    );
  }
}

final class DeleteUserRoleUseCaseImpl implements IDeleteUserRoleUseCase {
  final IUserRoleRepository _repository;

  DeleteUserRoleUseCaseImpl({required IUserRoleRepository repository})
      : _repository = repository;

  @override
  Future<VoidResult> call(DeleteUserRoleParams params) async {
    return _repository.deleteUserRole(params.userRoleId);
  }
}

final class GetAllUserRolesUseCaseImpl implements IGetAllUserRolesUseCase {
  final IUserRoleRepository _repository;

  GetAllUserRolesUseCaseImpl({required IUserRoleRepository repository})
      : _repository = repository;

  @override
  Future<AllUserRolesResult> call(NoParams params) async {
    return _repository.getAllUserRoles();
  }
}