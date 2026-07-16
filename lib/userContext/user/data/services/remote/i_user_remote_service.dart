import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:medquest/core/typedefs/type_defs.dart';

abstract interface class IUserRemoteService {
  Future<UserResult> getUser();
  Future<VoidResult> saveUser(User user);
  Future<VoidResult> updateUser(User user);
  Future<VoidResult> deleteUser();
}