import 'package:auto_injector/auto_injector.dart';
import '../theme/theme_controller.dart';
import 'package:medquest/auth/data/repositories/auth_repository_impl.dart';
import 'package:medquest/auth/data/repositories/i_auth_repository.dart';
import 'package:medquest/auth/data/services/local/auth_local_session_manager.dart';
import 'package:medquest/auth/data/services/local/i_local_session_store.dart';
import 'package:medquest/auth/data/services/local/shared_pref_local_session_service.dart';
import 'package:medquest/auth/data/services/remote/firebase_auth_service.dart';
import 'package:medquest/auth/data/services/remote/i_auth_service.dart';
import 'package:medquest/auth/domain/facades/auth_usecase_facade_impl.dart';
import 'package:medquest/auth/domain/facades/i_auth_usecase_facade.dart';
import 'package:medquest/auth/domain/usecases/auth_usecases_impl.dart';
import 'package:medquest/auth/domain/usecases/i_auth_usecases.dart';
import 'package:medquest/auth/presentation/controllers/auth_session_viewmodel.dart';

final injector = AutoInjector();

void setupDependencyInjection() {
  // Regristração de dependências do Core
  injector.addSingleton<ThemeController>(ThemeController.new);

  // --- AUTH ---
  // injector.addSingleton<IAccountRemoteService>(() => FirestoreAccountService());
  injector.addSingleton<ILocalSessionStore>(SharedPrefLocalSessionService.new);

  injector.addSingleton<AuthLocalSessionManager>(
    () => AuthLocalSessionManager(injector.get<ILocalSessionStore>()),
  );

  injector.addSingleton<IAuthService>(FirebaseAuthService.new);

  injector.addSingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      injector.get<IAuthService>(),
      injector.get<AuthLocalSessionManager>(),
    ),
  );

  // Use cases autenticação
  injector.addSingleton<ISignUpUseCase>(
    () => SignUpUseCase(authRepository: injector.get<IAuthRepository>()),
  );
  injector.addSingleton<ISignInUseCase>(
    () => SignInUseCase(authRepository: injector.get<IAuthRepository>()),
  );
  // injector.addSingleton<ISignInWithGoogleUseCase>(
  //   () => SignInWithGoogleUseCase(
  //     authRepository: injector.get<IAuthRepository>(),
  //   ),
  // );
  injector.addSingleton<ISignOutUseCase>(
    () => SignOutUseCase(authRepository: injector.get<IAuthRepository>()),
  );

  injector.addSingleton<IAuthUseCaseFacade>(
    () => AuthUseCaseFacadeImpl(
      signUpUseCase: injector.get<ISignUpUseCase>(),
      signInUseCase: injector.get<ISignInUseCase>(),
      // signInWithGoogleUseCase: injector.get<ISignInWithGoogleUseCase>(),
      signOutUseCase: injector.get<ISignOutUseCase>(),
    ),
  );

  // viewmodels
  injector.addSingleton<AuthViewModel>(
    () => AuthViewModel(
      injector.get<IAuthRepository>(),
      injector.get<IAuthUseCaseFacade>(),
    ),
  );

  injector.commit();
}
