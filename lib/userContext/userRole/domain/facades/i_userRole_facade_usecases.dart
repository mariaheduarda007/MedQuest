import 'package:medquest/core/typedefs/type_defs.dart';

abstract interface class IUserRoleFacadeUseCases {
  Future<UserRolesResult> getUserRolesByUserId(UserRolesParams params);
  Future<VoidResult> createUserRole(CreateUserRoleParams params);
  Future<VoidResult> updateUserRole(UpdateUserRoleParams params);
  Future<VoidResult> deleteUserRole(DeleteUserRoleParams params);
  Future<AllUserRolesResult> getAllUserRoles(NoParams params);
}