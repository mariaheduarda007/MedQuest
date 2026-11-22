import 'package:medquest/group/presentation/commands/group_commands.dart';
import 'package:medquest/group/presentation/controllers/group_state_viewmodel.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/patient/presentation/commands/patient_commands.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../../core/typedefs/type_defs.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GroupCommandsViewModel {
  final GroupStateViewModel state;
  final DeleteGroupCommand _deleteGroupCommand;
  final GetPatientsCommand _getPatientsCommand;
  final CreatePatientCommand _createPatientCommand;

  GroupCommandsViewModel({
    required this.state,
    required DeleteGroupCommand deleteGroupCommand,
    required CreatePatientCommand createPatientCommand,
    required GetPatientsCommand getPatientsCommand,
  }) : _getPatientsCommand = getPatientsCommand,
       _createPatientCommand = createPatientCommand,
       _deleteGroupCommand = deleteGroupCommand {
    // Observers para cada comando
    _observeDeleteGroup();
    _observeCreatePatient();
    _observeGetPatients();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  GetPatientsCommand get getPatientsCommand => _getPatientsCommand;
  CreatePatientCommand get createPatientCommand => _createPatientCommand;
  DeleteGroupCommand get deleteGroupCommand => _deleteGroupCommand;

  // ========================================================
  //   MÉTODO GENÉRICO DE OBSERVAÇÃO DE COMANDOS
  // ========================================================
  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      // 1) Ignora enquanto está executando
      if (command.isExecuting.value) return;

      // 2) Ignora até existir um resultado
      final result = command.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (data) {
          state.clearMessage();
          onSuccess(data);
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg);
          if (onFailure != null) onFailure(err);
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  void _observeCreatePatient() {
    _observeCommand<Patient>(
      _createPatientCommand,
      onSuccess: (patient) {
        state.setPatient(patient);
        state.setPatients([
          ...(state.patientsState.value ?? const <Patient>[]),
          patient,
        ]);
        state.patientSuccessEvent.value = PatientSuccessEvent.created;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetPatients() {
    _observeCommand<List<Patient>>(
      _getPatientsCommand,
      onSuccess: (patients) {
        state.setPatients(patients);
        state.clearPatientsMessage();
      },
      onFailure: (err) {
        state.setPatientsMessage(err.msg);
      },
    );
  }

  void _observeDeleteGroup() {
    _observeCommand<void>(
      _deleteGroupCommand,
      onSuccess: (_) {
        state.successEvent.value = GroupSuccessEvent.deleted;
        state.setGroup(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS QUE DISPARAM COMMANDS (CHAMADOS PELOS WIDGETS)
  // ========================================================
  Future<void> getPatients(String researchId, String groupId) async {
    await _getPatientsCommand.executeWith((
      researchId: researchId,
      groupId: groupId,
    ));
  }

  Future<PatientResult> createPatient({
    required Patient patient,
    required String researchId,
    required String groupId,
  }) {
    return _createPatientCommand.executeWith((
      patient: patient,
      researchId: researchId,
      groupId: groupId,
    ));
  }

  Future<VoidResult> deleteGroup({
    required String researchId,
    required String groupId,
  }) {
    return _deleteGroupCommand.executeWith((
      groupId: groupId,
      researchId: researchId,
    ));
  }
}
