import 'package:medquest/userContext/user/data/services/remote/i_user_remote_service.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'i_user_repository.dart';
// import '../services/local/user_local_storage_interface.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';

final class UserRepositoryImpl implements IUserRepository {
  // final IUserLocalStorage _localStorage;
  final IUserRemoteService _remoteService; 

  UserRepositoryImpl({
    // required IUserLocalStorage localStorage,
    required IUserRemoteService remoteService,
  }) : _remoteService = remoteService;
  //_localStorage = localStorage,
       

  @override
  Future<VoidResult> saveUser(User user) async {
    final remoteResult = await _remoteService.saveUser(user);

    return remoteResult.fold(
      // onSuccess: (ok) => _localStorage.saveUser(user),
      onSuccess: (ok) => Success(null),
      onFailure: (failure) =>
          Error(failure), 
    );
  }

  @override
  Future<UserResult> getUser() async {
    final result = await _remoteService.getUser();

    return result.fold(
      onSuccess: (user) {
        // _localStorage.saveUser(user);
        return Success(user);
      },
      onFailure: (failure) => Error(failure), 
    );
  }

  @override
  Future<VoidResult> deleteUser() async {
    final remoteResult = await _remoteService.deleteUser();

    return remoteResult.fold(
      // onSuccess: (ok) => _localStorage.deleteUser(),
      onSuccess: (ok) => Success(null),
      onFailure: (failure) => Error(failure),
    );
  }

  @override
  Future<VoidResult> updateUser(User user) async {
    final remoteResult = await _remoteService.updateUser(user);

    return remoteResult.fold(
      // onSuccess: (ok) => _localStorage.updateUser(user),
      onSuccess: (ok) => Success(null),
      onFailure: (failure) => Error(failure),
    );
  }
}
