import 'package:auto_injector/auto_injector.dart';
import 'package:medquest/userContext/userRole/domain/usecases/userRole_usecases_impl.dart';
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
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/data/services/remote/i_userRole_remote_service.dart';
import 'package:medquest/userContext/userRole/data/services/remote/firestore_userRole_remote_service.dart';
import 'package:medquest/userContext/userRole/data/repositories/i_userRole_repository.dart';
import 'package:medquest/userContext/userRole/data/repositories/userRole_repository_impl.dart';
import 'package:medquest/userContext/userRole/domain/usecases/i_userRole_usecases.dart';
import 'package:medquest/userContext/userRole/domain/facades/i_userRole_facade_usecases.dart';
import 'package:medquest/userContext/userRole/domain/facades/userRole_facade_usecases_impl.dart';
import 'package:medquest/userContext/userRole/presentation/controllers/userRole_viewmodel.dart';

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
  injector.addSingleton<ISignOutUseCase>(
    () => SignOutUseCase(authRepository: injector.get<IAuthRepository>()),
  );

  injector.addSingleton<IAuthUseCaseFacade>(
    () => AuthUseCaseFacadeImpl(
      signUpUseCase: injector.get<ISignUpUseCase>(),
      signInUseCase: injector.get<ISignInUseCase>(),
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

// --- USER ROLE ---
  injector.addSingleton<IUserRoleRemoteService>(
    () => FirestoreUserRoleRemoteService(firestore: injector.get<FirebaseFirestore>()),
  );

  injector.addSingleton<IUserRoleRepository>(
    () => UserRoleRepository(remoteService: injector.get<IUserRoleRemoteService>()),
  );

  injector.addSingleton<IGetUserRolesByUserIdUseCase>(
    () => GetUserRolesByUserIdUseCaseImpl(repository: injector.get<IUserRoleRepository>()),
  );
  injector.addSingleton<IGetAllUserRolesUseCase>(
    () => GetAllUserRolesUseCaseImpl(repository: injector.get<IUserRoleRepository>()),
  );
  injector.addSingleton<ICreateUserRoleUseCase>(
    () => CreateUserRoleUseCaseImpl(repository: injector.get<IUserRoleRepository>()),
  );
  injector.addSingleton<IUpdateUserRoleUseCase>(
    () => UpdateUserRoleUseCaseImpl(repository: injector.get<IUserRoleRepository>()),
  );
  injector.addSingleton<IDeleteUserRoleUseCase>(
    () => DeleteUserRoleUseCaseImpl(repository: injector.get<IUserRoleRepository>()),
  );

  injector.addSingleton<IUserRoleFacadeUseCases>(
    () => UserRoleFacadeUsecasesImpl(
      getUserRolesByUserIdUseCase: injector.get<IGetUserRolesByUserIdUseCase>(),
      getAllUserRolesUseCase: injector.get<IGetAllUserRolesUseCase>(),
      createUserRoleUseCase: injector.get<ICreateUserRoleUseCase>(),
      updateUserRoleUseCase: injector.get<IUpdateUserRoleUseCase>(),
      deleteUserRoleUseCase: injector.get<IDeleteUserRoleUseCase>(),
    ),
  );

  injector.addSingleton<UserRoleViewModel>(
    () => UserRoleViewModel(injector.get<IUserRoleFacadeUseCases>()),
  );
  injector.commit();
}
