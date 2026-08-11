import '../commands/patient_commands.dart';
import 'patient_commands_viewmodel.dart';
import 'patient_state_viewmodel.dart';

class PatientViewModel {
  late final PatientStateViewModel _state;

  /// Getter público para acessar o estado de Patient
  PatientStateViewModel get patientState => _state;

  /// dispara os commands e effects e observa as mudanças de estado
  late final PatientCommandsViewModel commands;

  /// Construtor que inicializa a VieModel principal que será consumida na UI
  /// injeta a dependência do Facade dos casos de uso de Patient

  // PatientViewModel(IPatientFacadeUseCases facade) {
  //   _state = PatientStateViewModel();

  //   commands = PatientCommandsViewModel(
  //     state: _state,
  //     createPatientCommand: CreatePatientCommand(facade),
  //     updatePatientCommand: UpdatePatientCommand(facade),
  //     getPatientCommand: GetPatientCommand(facade),
  //     deletePatientCommand: DeletePatientCommand(facade),
  //   );
  // }

  //mudei o construtor para que ele nao dependa de nada, e coloquei stateviewmodel na di
  PatientViewModel({
    required PatientStateViewModel state,
    required this.commands,
  }) : _state = state;

  // --- Comandos expostos ---
  CreatePatientCommand get savePatientCommand => commands.createPatientCommand;
  GetPatientCommand get getPatientCommand => commands.getPatientCommand;
  GetPatientsCommand get getPatientsCommand => commands.getPatientsCommand;
  UpdatePatientCommand get updatePatientCommand =>
      commands.updatePatientCommand;
  DeletePatientCommand get deletePatientCommand =>
      commands.deletePatientCommand;
}
