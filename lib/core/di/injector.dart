import 'package:auto_injector/auto_injector.dart';
import 'package:medquest/answeredquest/domain/facade/answeredquest_facade_usecases_impl.dart';
import 'package:medquest/answeredquest/domain/facade/answeredquest_facade_usecases_interface.dart';
import 'package:medquest/answeredquest/domain/usecases/answeredquest_usecases_impl.dart';
import 'package:medquest/answeredquest/domain/usecases/answeredquest_usecases_interface.dart';
import 'package:medquest/answeredquest/presentation/commands/answeredquest_commands.dart';
import 'package:medquest/group/data/repositories/group_repository_impl.dart';
import 'package:medquest/group/data/repositories/group_repository_interface.dart';
import 'package:medquest/group/data/services/group_firestore_impl.dart';
import 'package:medquest/group/data/services/group_firestore_interface.dart';
import 'package:medquest/group/domain/facades/group_facade_usecases_impl.dart';
import 'package:medquest/group/domain/facades/group_facade_usecases_interface.dart';
import 'package:medquest/group/domain/usecases/group_usecases_impl.dart';
import 'package:medquest/group/domain/usecases/group_usecases_interface.dart';
import 'package:medquest/group/presentation/commands/group_commands.dart';
import 'package:medquest/group/presentation/controllers/group_commands_viewmodel.dart';
import 'package:medquest/group/presentation/controllers/group_state_viewmodel.dart';
import 'package:medquest/group/presentation/controllers/group_viewmodel.dart';
import 'package:medquest/modelquest/data/repository/modelquest_repository_impl.dart';
import 'package:medquest/modelquest/data/repository/modelquest_repository_interface.dart';
import 'package:medquest/modelquest/data/service/modelquest_firestore_impl.dart';
import 'package:medquest/modelquest/data/service/modelquest_firestore_interface.dart';
import 'package:medquest/modelquest/domain/facade/modelquest_facade_usecases_impl.dart';
import 'package:medquest/modelquest/domain/facade/modelquest_facade_usecases_interface.dart';
import 'package:medquest/modelquest/domain/usecases/modelquest_usecases_impl.dart';
import 'package:medquest/modelquest/domain/usecases/modelquest_usecases_interface.dart';
import 'package:medquest/modelquest/presentation/commands/modelquest_commands.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_commands_viewmodel.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_state_viewmodel.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquest_viewmodel.dart';
import 'package:medquest/answeredquest/data/repository/answeredquest_repository_impl.dart';
import 'package:medquest/answeredquest/data/repository/answeredquest_repository_interface.dart';
import 'package:medquest/answeredquest/data/service/answeredquest_firestore_impl.dart';
import 'package:medquest/answeredquest/data/service/answeredquest_firestore_interface.dart';
import 'package:medquest/patient/data/repository/patient_repository_impl.dart';
import 'package:medquest/patient/data/repository/patient_repository_interface.dart';
import 'package:medquest/patient/data/service/patient_firestore_impl.dart';
import 'package:medquest/patient/data/service/patient_firestore_interface.dart';
import 'package:medquest/patient/domain/facade/patient_facade_usecases_impl.dart';
import 'package:medquest/patient/domain/facade/patient_facade_usecases_interface.dart';
import 'package:medquest/patient/domain/usecases/patient_usecases_impl.dart';
import 'package:medquest/patient/domain/usecases/patient_usecases_interface.dart';
import 'package:medquest/patient/presentation/commands/patient_commands.dart';
import 'package:medquest/patient/presentation/controllers/patient_commands_viewmodel.dart';
import 'package:medquest/patient/presentation/controllers/patient_state_viewmodel.dart';
import 'package:medquest/patient/presentation/controllers/patient_viewmodel.dart';
import 'package:medquest/research/data/repository/research_repository.dart';
import 'package:medquest/research/data/repository/research_repository_impl.dart';
import 'package:medquest/research/data/service/research_firestore_impl.dart';
import 'package:medquest/research/data/service/research_firestore_interface.dart';
import 'package:medquest/research/domain/facade/research_facade_usecases_impl.dart';
import 'package:medquest/research/domain/facade/research_facade_usecases_interface.dart';
import 'package:medquest/research/domain/usecases/research_usecases_impl.dart';
import 'package:medquest/research/domain/usecases/research_usecases_interface.dart';
import 'package:medquest/research/presentation/commands/research_commands.dart';
import 'package:medquest/research/presentation/controllers/research_commands_viewmodel.dart';
import 'package:medquest/research/presentation/controllers/research_state_viewmodel.dart';
import 'package:medquest/research/presentation/controllers/research_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medquest/userContext/userRole/domain/usecases/userRole_usecases_impl.dart';
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
  // injector.addSingleton<AppTheme>(AppTheme.new);
  injector.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  injector.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  injector.addSingleton<IPatientFirestore>(PatientFirestoreService.new);
  injector.addSingleton<IPatientRepository>(PatientRepositoryImpl.new);
  injector.addSingleton<IPatientFacadeUseCases>(PatientFacadeUsecasesImpl.new);
  injector.addSingleton<ICreatePatientUseCase>(CreatePatientUseCaseImpl.new);
  injector.addSingleton<IGetPatientUseCase>(GetPatientUseCaseImpl.new);
  injector.addSingleton<IGetPatientsUseCase>(GetPatientsUseCaseImpl.new);
  injector.addSingleton<IUpdatePatientUseCase>(UpdatePatientUseCaseImpl.new);
  injector.addSingleton<IDeletePatientUseCase>(DeletePatientUseCaseImpl.new);
  injector.addSingleton<CreatePatientCommand>(CreatePatientCommand.new);
  injector.addSingleton<GetPatientCommand>(GetPatientCommand.new);
  injector.addSingleton<GetPatientsCommand>(GetPatientsCommand.new);
  injector.addSingleton<UpdatePatientCommand>(UpdatePatientCommand.new);
  injector.addSingleton<DeletePatientCommand>(DeletePatientCommand.new);
  injector.addSingleton<PatientStateViewModel>(PatientStateViewModel.new);
  injector.addSingleton<PatientCommandsViewModel>(PatientCommandsViewModel.new);
  injector.addSingleton<PatientViewModel>(PatientViewModel.new);

  injector.addSingleton<IGroupFirestore>(GroupFirestoreService.new);
  injector.addSingleton<IGroupRepository>(GroupRepositoryImpl.new);
  injector.addSingleton<IGroupFacadeUseCases>(GroupFacadeUsecasesImpl.new);
  injector.addSingleton<IGetGroupUseCase>(GetGroupUseCaseImpl.new);
  injector.addSingleton<IGetGroupsUseCase>(GetGroupsUseCaseImpl.new);
  injector.addSingleton<ICreateGroupUseCase>(CreateGroupUseCaseImpl.new);
  injector.addSingleton<IDeleteGroupUseCase>(DeleteGroupUseCaseImpl.new);
  injector.addSingleton<CreateGroupCommand>(CreateGroupCommand.new);
  injector.addSingleton<GetGroupCommand>(GetGroupCommand.new);
  injector.addSingleton<GetGroupsCommand>(GetGroupsCommand.new);
  injector.addSingleton<DeleteGroupCommand>(DeleteGroupCommand.new);
  injector.addSingleton<GroupStateViewModel>(GroupStateViewModel.new);
  injector.addSingleton<GroupCommandsViewModel>(GroupCommandsViewModel.new);
  injector.addSingleton<GroupViewModel>(GroupViewModel.new);

  injector.addSingleton<IResearchFirestore>(ResearchFirestoreService.new);
  injector.addSingleton<IResearchRepository>(ResearchRepositoryImpl.new);
  injector.addSingleton<IResearchFacadeUseCases>(
    ResearchFacadeUsecasesImpl.new,
  );
  injector.addSingleton<ICreateResearchUseCase>(CreateResearchUseCaseImpl.new);
  injector.addSingleton<IGetResearchUseCase>(GetResearchUseCaseImpl.new);
  injector.addSingleton<IGetResearchesUseCase>(GetResearchesUseCaseImpl.new);
  injector.addSingleton<IUpdateResearchUseCase>(UpdateResearchUseCaseImpl.new);
  injector.addSingleton<IDeleteResearchUseCase>(DeleteResearchUseCaseImpl.new);
  injector.addSingleton<IArchiveResearchUseCase>(
    ArchiveResearchUseCaseImpl.new,
  );
  injector.addSingleton<IUnarchiveResearchUseCase>(
    UnarchiveResearchUseCaseImpl.new,
  );
  injector.addSingleton<CreateResearchCommand>(CreateResearchCommand.new);
  injector.addSingleton<GetResearchCommand>(GetResearchCommand.new);
  injector.addSingleton<GetResearchesCommand>(GetResearchesCommand.new);
  injector.addSingleton<UpdateResearchCommand>(UpdateResearchCommand.new);
  injector.addSingleton<DeleteResearchCommand>(DeleteResearchCommand.new);
  injector.addSingleton<ArchiveResearchCommand>(ArchiveResearchCommand.new);
  injector.addSingleton<UnarchiveResearchCommand>(UnarchiveResearchCommand.new);
  injector.addSingleton<ResearchStateViewModel>(ResearchStateViewModel.new);
  injector.addSingleton<ResearchCommandsViewModel>(
    ResearchCommandsViewModel.new,
  );
  injector.addSingleton<ResearchViewModel>(ResearchViewModel.new);

  injector.addSingleton<IModelQuestFirestore>(ModelQuestFirestoreService.new);
  injector.addSingleton<IModelQuestRepository>(ModelQuestRepositoryImpl.new);
  injector.addSingleton<IModelQuestFacadeUseCases>(
    ModelQuestFacadeUsecasesImpl.new,
  );
  injector.addSingleton<ICreateModelQuestUseCase>(
    CreateModelQuestUseCaseImpl.new,
  );
  injector.addSingleton<IGetModelQuestUseCase>(GetModelQuestUseCaseImpl.new);
  injector.addSingleton<IGetAllModelQuestsUseCase>(
    GetAllModelQuestsUseCaseImpl.new,
  );
  injector.addSingleton<IGetModelQuestsFromResearchUseCase>(
    GetModelQuestsFromResearchUseCaseImpl.new,
  );
  injector.addSingleton<IUpdateModelQuestUseCase>(
    UpdateModelQuestUseCaseImpl.new,
  );
  injector.addSingleton<IDeleteModelQuestUseCase>(
    DeleteModelQuestUseCaseImpl.new,
  );
  injector.addSingleton<ICreateQuestionUseCase>(CreateQuestionUseCaseImpl.new);
  injector.addSingleton<IUpdateQuestionUseCase>(UpdateQuestionUseCaseImpl.new);
  injector.addSingleton<IDeleteQuestionUseCase>(DeleteQuestionUseCaseImpl.new);
  injector.addSingleton<CreateModelQuestCommand>(CreateModelQuestCommand.new);
  injector.addSingleton<GetModelQuestCommand>(GetModelQuestCommand.new);
  injector.addSingleton<GetAllModelQuestsCommand>(GetAllModelQuestsCommand.new);
  injector.addSingleton<GetModelQuestsFromResearchCommand>(
    GetModelQuestsFromResearchCommand.new,
  );
  injector.addSingleton<UpdateModelQuestCommand>(UpdateModelQuestCommand.new);
  injector.addSingleton<DeleteModelQuestCommand>(DeleteModelQuestCommand.new);
  injector.addSingleton<CreateQuestionCommand>(CreateQuestionCommand.new);
  injector.addSingleton<UpdateQuestionCommand>(UpdateQuestionCommand.new);
  injector.addSingleton<DeleteQuestionCommand>(DeleteQuestionCommand.new);
  injector.addSingleton<ModelQuestStateViewModel>(ModelQuestStateViewModel.new);
  injector.addSingleton<ModelQuestCommandsViewModel>(
    ModelQuestCommandsViewModel.new,
  );
  injector.addSingleton<ModelQuestViewModel>(ModelQuestViewModel.new);



  injector.addSingleton<IAnsweredQuestFirestore>(AnsweredQuestFirestoreService.new);
  injector.addSingleton<IAnsweredQuestRepository>(AnsweredQuestRepositoryImpl.new);
  injector.addSingleton<IAnsweredQuestFacadeUseCases>(AnsweredQuestFacadeUsecasesImpl.new);
   injector.addSingleton<ICreateAnsweredQuestUseCase>(
    CreateAnsweredQuestUseCaseImpl.new,
  );
  injector.addSingleton<IGetAnsweredQuestUseCase>(
    GetAnsweredQuestUseCaseImpl.new,
  );
  injector.addSingleton<IGetAnsweredQuestsUseCase>(
    GetAnsweredQuestsUseCaseImpl.new,
  );
  injector.addSingleton<IUpdateAnsweredQuestUseCase>(
    UpdateAnsweredQuestUseCaseImpl.new,
  );
  injector.addSingleton<IDeleteAnsweredQuestUseCase>(
    DeleteAnsweredQuestUseCaseImpl.new,
  );
  injector.addSingleton<CreateAnsweredQuestCommand>(
    CreateAnsweredQuestCommand.new,
  );
  injector.addSingleton<GetAnsweredQuestCommand>(GetAnsweredQuestCommand.new);
  injector.addSingleton<GetAnsweredQuestsCommand>(GetAnsweredQuestsCommand.new);
  injector.addSingleton<UpdateAnsweredQuestCommand>(
    UpdateAnsweredQuestCommand.new,
  );
  injector.addSingleton<DeleteAnsweredQuestCommand>(
    DeleteAnsweredQuestCommand.new,
  );

//--------------------------------------------------------------------------
  
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
    () => UserRoleRepositoryImpl(remoteService: injector.get<IUserRoleRemoteService>()),
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
