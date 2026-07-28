import 'package:auto_injector/auto_injector.dart';
import 'package:medquest/data/repositories/group_repository_impl.dart';
import 'package:medquest/data/repositories/group_repository_interface.dart';
import 'package:medquest/data/repositories/patient_repository_impl.dart';
import 'package:medquest/data/repositories/patient_repository_interface.dart';
import 'package:medquest/data/services/group_firestore_impl.dart';
import 'package:medquest/data/services/group_firestore_interface.dart';
import 'package:medquest/data/services/patient_firestore_impl.dart';
import 'package:medquest/data/services/patient_firestore_interface.dart';
import 'package:medquest/domain/facades/group_facade_usecases_impl.dart';
import 'package:medquest/domain/facades/group_facade_usecases_interface.dart';
import 'package:medquest/domain/facades/patient_facade_usecases_impl.dart';
import 'package:medquest/domain/facades/patient_facade_usecases_interface.dart';
import 'package:medquest/domain/usecases/group_usecases_impl.dart';
import 'package:medquest/domain/usecases/group_usecases_interface.dart';
import 'package:medquest/domain/usecases/patient_usecases_impl.dart';
import 'package:medquest/domain/usecases/patient_usecases_interface.dart';
import 'package:medquest/presentation/commands/group_commands.dart';
import 'package:medquest/presentation/commands/patient_commands.dart';
import 'package:medquest/presentation/controllers/group_commands_viewmodel.dart';
import 'package:medquest/presentation/controllers/group_state_viewmodel.dart';
import 'package:medquest/presentation/controllers/group_viewmodel.dart';
import 'package:medquest/presentation/controllers/patient_commands_viewmodel.dart';
import 'package:medquest/presentation/controllers/patient_state_viewmodel.dart';
import 'package:medquest/presentation/controllers/patient_viewmodel.dart';
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

  injector.commit();
}
