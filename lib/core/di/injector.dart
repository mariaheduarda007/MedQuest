import 'package:auto_injector/auto_injector.dart';
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
import '../theme/theme_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final injector = AutoInjector();
void setupDependencyInjection() {
  injector.addSingleton<ThemeController>(ThemeController.new);
  injector.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  injector.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  injector.addSingleton<IPatientFirestore>(PatientFirestoreService.new);
  injector.addSingleton<IPatientRepository>(PatientRepositoryImpl.new);
  injector.addSingleton<IModelQuestFirestore>(ModelQuestFirestoreService.new);
  injector.addSingleton<IModelQuestRepository>(ModelQuestRepositoryImpl.new);
  injector.addSingleton<IPatientFacadeUseCases>(PatientFacadeUsecasesImpl.new);
  injector.addSingleton<ICreatePatientUseCase>(CreatePatientUseCaseImpl.new);
  injector.addSingleton<IGetPatientUseCase>(GetPatientUseCaseImpl.new);
  injector.addSingleton<IUpdatePatientUseCase>(UpdatePatientUseCaseImpl.new);
  injector.addSingleton<IDeletePatientUseCase>(DeletePatientUseCaseImpl.new);
  injector.addSingleton<CreatePatientCommand>(CreatePatientCommand.new);
  injector.addSingleton<GetPatientCommand>(GetPatientCommand.new);
  injector.addSingleton<UpdatePatientCommand>(UpdatePatientCommand.new);
  injector.addSingleton<DeletePatientCommand>(DeletePatientCommand.new);
  injector.addSingleton<PatientStateViewModel>(PatientStateViewModel.new);
  injector.addSingleton<PatientCommandsViewModel>(PatientCommandsViewModel.new);
  injector.addSingleton<PatientViewModel>(PatientViewModel.new);



  injector.addSingleton<IGroupFirestore>(GroupFirestoreService.new);
  injector.addSingleton<IGroupRepository>(GroupRepositoryImpl.new);
  injector.addSingleton<IGroupFacadeUseCases>(GroupFacadeUsecasesImpl.new);
  injector.addSingleton<IGetGroupUseCase>(GetGroupUseCaseImpl.new);
  injector.addSingleton<ICreateGroupUseCase>(CreateGroupUseCaseImpl.new);
  injector.addSingleton<IDeleteGroupUseCase>(DeleteGroupUseCaseImpl.new);
  injector.addSingleton<CreateGroupCommand>(CreateGroupCommand.new);
  injector.addSingleton<GetGroupCommand>(GetGroupCommand.new);
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

  

  injector.commit();
}
