import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../domain/models/patient_entity.dart';
import '../commands/patient_commands.dart';
import 'patient_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PatientCommandsViewmodel {
  final PatientStateViewModel state;
  final GetPatientCommand _getPatientCommand;
  final CreatePatientCommand _createPatientCommand;
  final UpdatePatientCommand _updatePatientCommand;
  final DeletePatientCommand _deletePatientCommand;

  PatientCommandsViewmodel({
    required this.state,
    required GetPatientCommand getPatientCommand,
    required CreatePatientCommand createPatientCommand,
    required UpdatePatientCommand updatePatientCommand,
    required DeletePatientCommand deletePatientCommand,
  }) : _getPatientCommand = getPatientCommand,
       _createPatientCommand = createPatientCommand,
       _updatePatientCommand = updatePatientCommand,
       _deletePatientCommand = deletePatientCommand {
    // Observers para cada comando
    _observeGetPatient();
    _observeDeletePatient();
    _observeCreatePatient();
    _observeUpdatePatient();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  GetPatientCommand get getPatientCommand => _getPatientCommand;
  CreatePatientCommand get createPatientCommand => _createPatientCommand;
  UpdatePatientCommand get updatePatientCommand => _updatePatientCommand;
  DeletePatientCommand get deletePatientCommand => _deletePatientCommand;

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
        state.successEvent.value = PatientSuccessEvent.created;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetPatient() {
    _observeCommand<Patient>(
      _getPatientCommand,
      onSuccess: (patient) {
        state.setPatient(patient);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      }, //redundante, pois o generico já faz isso, mas mantido para verificar minha suposição
    );
  }

  void _observeUpdatePatient() {
    _observeCommand<Patient>(
      _updatePatientCommand,
      onSuccess: (patient) {
        state.setPatient(patient);
        state.successEvent.value = PatientSuccessEvent.updated;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeDeletePatient() {
    _observeCommand<void>(
      _deletePatientCommand,
      onSuccess: (_) {
        state.successEvent.value = PatientSuccessEvent.deleted;
        state.setPatient(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS QUE DISPARAM COMMANDS (CHAMADOS PELOS WIDGETS)
  // ========================================================
  Future<void> createPatient(
    Patient patient,
    String researchId,
    String groupId,
  ) async {
    //só executa o command, state e suas funções são atualizados pelos observers
    await _createPatientCommand.executeWith((
      patient: patient,
      researchId: researchId,
      groupId: groupId,
    ));
  }

  Future<void> getPatient(
    String researchId,
    String groupId,
    String patientId,
  ) async {
    await _getPatientCommand.executeWith((
      researchId: researchId,
      groupId: groupId,
      patientId: patientId,
    ));
  }

  Future<void> updatePatient(
    Patient patient,
    String researchId,
    String groupId,
  ) async {
    await _updatePatientCommand.executeWith((
      patient: patient,
      researchId: researchId,
      groupId: groupId,
    ));
  }

  Future<void> deletePatient(
    String researchId,
    String groupId,
    String patientId,
  ) async {
    await _deletePatientCommand.executeWith((
      groupId: groupId,
      researchId: researchId,
      patientId: patientId,
    ));
  }
}
