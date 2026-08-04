import 'package:medquest/core/typedefs/type_defs.dart';

import '../usecases/i_auth_usecases.dart';
import 'i_auth_usecase_facade.dart';

class AuthUseCaseFacadeImpl implements IAuthUseCaseFacade {
  final ISignInUseCase _signInUseCase;
  final ISignOutUseCase _signOutUseCase;
  final ISignUpUseCase _signUpUseCase;

  AuthUseCaseFacadeImpl({
    required ISignInUseCase signInUseCase,
    required ISignOutUseCase signOutUseCase,
    required ISignUpUseCase signUpUseCase,
  }) : _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase,
       _signUpUseCase = signUpUseCase;

  @override
  Future<AuthSessionResult> signInUseCase(SignInParams params) {
    return _signInUseCase(params);
  }

  @override
  Future<VoidResult> signOutUseCase(NoParams params) {
    return _signOutUseCase(params);
  }

  @override
  Future<AuthSessionResult> signUpUseCase(SignUpParams params) {
    return _signUpUseCase(params);
  }
}