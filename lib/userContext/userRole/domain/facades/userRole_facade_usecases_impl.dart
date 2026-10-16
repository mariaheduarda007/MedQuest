import 'package:medquest/core/typedefs/type_defs.dart';
import 'i_userRole_facade_usecases.dart';
import '../usecases/i_userRole_usecases.dart';

final class UserRoleFacadeUsecasesImpl implements IUserRoleFacadeUseCases {
  final IGetUserRolesByUserIdUseCase _getUserRolesByUserIdUseCase;
  final ICreateUserRoleUseCase _createUserRoleUseCase;
  final IUpdateUserRoleUseCase _updateUserRoleUseCase;
  final IDeleteUserRoleUseCase _deleteUserRoleUseCase;
  final IGetAllUserRolesUseCase _getAllUserRolesUseCase;

  UserRoleFacadeUsecasesImpl({
    required IGetUserRolesByUserIdUseCase getUserRolesByUserIdUseCase,
    required ICreateUserRoleUseCase createUserRoleUseCase,
    required IUpdateUserRoleUseCase updateUserRoleUseCase,
    required IDeleteUserRoleUseCase deleteUserRoleUseCase,
    required IGetAllUserRolesUseCase getAllUserRolesUseCase,
  })  : _getUserRolesByUserIdUseCase = getUserRolesByUserIdUseCase,
        _createUserRoleUseCase = createUserRoleUseCase,
        _updateUserRoleUseCase = updateUserRoleUseCase,
        _deleteUserRoleUseCase = deleteUserRoleUseCase,
        _getAllUserRolesUseCase = getAllUserRolesUseCase;

  @override
  Future<UserRolesResult> getUserRolesByUserId(UserRolesParams params) {
    return _getUserRolesByUserIdUseCase(params);
  }

  @override
  Future<VoidResult> createUserRole(CreateUserRoleParams params) {
    return _createUserRoleUseCase(params);
  }

  @override
  Future<VoidResult> updateUserRole(UpdateUserRoleParams params) {
    return _updateUserRoleUseCase(params);
  }

  @override
  Future<VoidResult> deleteUserRole(DeleteUserRoleParams params) {
    return _deleteUserRoleUseCase(params);
  }

  @override
  Future<AllUserRolesResult> getAllUserRoles(NoParams params) { 
    return _getAllUserRolesUseCase(params);
  }
}