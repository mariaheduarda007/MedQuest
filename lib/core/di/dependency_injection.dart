import 'package:auto_injector/auto_injector.dart';
import '../theme/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:medquest/userContext/user/data/repositories/i_user_repository.dart';
import 'package:medquest/userContext/user/data/repositories/user_repository_impl.dart';
import 'package:medquest/userContext/user/data/services/remote/i_user_remote_service.dart';
import 'package:medquest/userContext/user/domain/facades/i_user_facade_usecases.dart';
import 'package:medquest/userContext/user/domain/facades/user_facade_usecases_impl.dart';
import 'package:medquest/userContext/user/domain/usecases/i_user_usecases.dart';
import 'package:medquest/userContext/user/domain/usecases/user_usecases_impl.dart';
import 'package:medquest/userContext/user/presentation/controllers/user_viewmodel.dart';
import 'package:medquest/userContext/user/data/services/remote/firestore_user_remote_service.dart';
import 'package:medquest/userContext/permission/data/services/local/permission_cache_service.dart';

final injector = AutoInjector();

void setupDependencyInjection() {
  // Regristração de dependências do Core
  injector.addSingleton<ThemeController>(ThemeController.new);

  injector.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  // --- AUTH ---
  // injector.addSingleton<IAccountRemoteService>(() => FirestoreAccountService());
  injector.addSingleton<ILocalSessionStore>(SharedPrefLocalSessionService.new);

  injector.addSingleton<AuthLocalSessionManager>(
    () => AuthLocalSessionManager(injector.get<ILocalSessionStore>()),
  );

  injector.addSingleton<IAuthService>(
    () => FirebaseAuthService(
      localSession: injector.get<AuthLocalSessionManager>(),
      firestore: injector.get<FirebaseFirestore>(),
    ),
  );

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

// --- PERMISSION ---

injector.addSingleton<PermissionCacheService>(() => PermissionCacheService(
  firestore: injector.get<FirebaseFirestore>(),
));

// --- USER ---
  
  injector.addSingleton<IUserRemoteService>(FirestoreUserService.new); 

  injector.addSingleton<IUserRepository>(
    () => UserRepositoryImpl(
      remoteService: injector.get<IUserRemoteService>(),
    ),
  );

  injector.addSingleton<IGetUserUseCase>(
    () => GetUserUseCaseImpl(repository: injector.get<IUserRepository>()),
  );
  injector.addSingleton<ISaveUserUseCase>(
    () => SaveUserUseCaseImpl(repository: injector.get<IUserRepository>()),
  );
  injector.addSingleton<IUpdateUserUseCase>(
    () => UpdateUserUseCaseImpl(repository: injector.get<IUserRepository>()),
  );
  injector.addSingleton<IDeleteUserUseCase>(
    () => DeleteUserUseCaseImpl(repository: injector.get<IUserRepository>()),
  );

  injector.addSingleton<IUserFacadeUseCases>(
    () => UserFacadeUsecasesImpl(
      getUserUseCase: injector.get<IGetUserUseCase>(),
      saveUserUseCase: injector.get<ISaveUserUseCase>(),
      updateUserUseCase: injector.get<IUpdateUserUseCase>(),
      deleteUserUseCase: injector.get<IDeleteUserUseCase>(),
    ),
  );

  injector.addSingleton<UserViewModel>(
    () => UserViewModel(injector.get<IUserFacadeUseCases>()),
  );

  injector.commit();
}
