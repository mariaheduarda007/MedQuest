import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';

abstract interface class IUserRepository {
  Future<UserResult> getUser();
  Future<VoidResult> saveUser(User user);
  Future<VoidResult> updateUser(User user);
  Future<VoidResult> deleteUser();
}