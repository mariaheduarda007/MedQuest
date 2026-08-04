import 'i_userRole_repository.dart';
import '../services/remote/i_userRole_remote_service.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';

class UserRoleRepository implements IUserRoleRepository {
  final IUserRoleRemoteService _remoteService;

  UserRoleRepository({required IUserRoleRemoteService remoteService})
    : _remoteService = remoteService;

  @override
  Future<Result<List<UserRoleModel>, Failure>> getUserRolesByUserId(
    String userId,
  ) async {
    final remoteResult = await _remoteService.getUserRolesByUserId(userId);

    return remoteResult.fold(
      onSuccess: (roles) => Success(roles),
      onFailure: (failure) => Error(failure),
    );
  }

  @override
  Future<VoidResult> createUserRole({
    required String userId,
    required String permissionId,
    String? researchId,
  }) async {
    final remoteResult = await _remoteService.createUserRole(
      userId: userId,
      permissionId: permissionId,
      researchId: researchId,
    );

    return remoteResult.fold(
      onSuccess: (ok) => Success(null),
      onFailure: (failure) => Error(failure),
    );
  }

  @override
  Future<VoidResult> updateUserRole({
    required String userRoleId,
    String? permissionId,
    String? researchId,
  }) async {
      final remoteResult = await _remoteService.updateUserRole(
        userRoleId: userRoleId,
        permissionId: permissionId,
        researchId: researchId,
      );
      return remoteResult.fold(
        onSuccess: (ok) => Success(null),
        onFailure: (failure) => Error(failure),
      );
    }

  @override
  Future<VoidResult> deleteUserRole(String userRoleId) async {
    final remoteResult = await _remoteService.deleteUserRole(userRoleId);

    return remoteResult.fold(
      onSuccess: (ok) => Success(null),
      onFailure: (failure) => Error(failure),
    );
  }

  @override
  Future<Result<List<UserRoleModel>, Failure>> getAllUserRoles() async {
    final remoteResult = await _remoteService.getAllUserRoles();

    return remoteResult.fold(
      onSuccess: (roles) => Success(roles),
      onFailure: (failure) => Error(failure),
    );
  }
}