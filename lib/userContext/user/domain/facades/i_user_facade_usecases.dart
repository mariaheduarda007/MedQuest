import 'package:medquest/core/typedefs/type_defs.dart';

abstract interface class IUserFacadeUseCases {
  Future<UserResult> getUser(NoParams params);
  Future<VoidResult> saveUser(UserParams params);
  Future<VoidResult> updateUser(UserParams params);
  Future<VoidResult> deleteUser(NoParams params);
}