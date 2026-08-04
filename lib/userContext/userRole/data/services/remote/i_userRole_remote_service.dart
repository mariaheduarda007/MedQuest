import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';

abstract interface class IUserRoleRemoteService {

  Future<Result<List<UserRoleModel>, Failure>> getUserRolesByUserId(
    String userId,
  );

  Future<VoidResult> createUserRole({
    required String userId,
    required String permissionId,
    String? researchId,
  });

  Future<VoidResult> updateUserRole({
    required String userRoleId,
    String? permissionId,
    String? researchId,
  });

  Future<VoidResult> deleteUserRole(String userRoleId);

  Future<Result<List<UserRoleModel>, Failure>> getAllUserRoles();
}
