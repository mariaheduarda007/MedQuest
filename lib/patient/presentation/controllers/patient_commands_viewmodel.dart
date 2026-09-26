import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/presentation/commands/answeredquest_commands.dart';

import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../domain/models/patient_entity.dart';
import '../commands/patient_commands.dart';
import 'patient_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PatientCommandsViewModel {
  final PatientStateViewModel state;
  final GetPatientCommand _getPatientCommand;
  final GetPatientsCommand _getPatientsCommand;
  final CreatePatientCommand _createPatientCommand;
  final UpdatePatientCommand _updatePatientCommand;
  final DeletePatientCommand _deletePatientCommand;
  final CreateAnsweredQuestCommand _createAnsweredQuestCommand;
  final GetAnsweredQuestCommand _getAnsweredQuestCommand;
  final GetAnsweredQuestsCommand _getAnsweredQuestsCommand;
  final UpdateAnsweredQuestCommand _updateAnsweredQuestCommand;
  final DeleteAnsweredQuestCommand _deleteAnsweredQuestCommand;

  PatientCommandsViewModel({
    required this.state,
    required CreatePatientCommand createPatientCommand,
    required GetPatientCommand getPatientCommand,
    required GetPatientsCommand getPatientsCommand,
    required UpdatePatientCommand updatePatientCommand,
    required DeletePatientCommand deletePatientCommand,
    required CreateAnsweredQuestCommand createAnsweredQuestCommand,
    required GetAnsweredQuestCommand getAnsweredQuestCommand,
    required GetAnsweredQuestsCommand getAnsweredQuestsCommand,
    required UpdateAnsweredQuestCommand updateAnsweredQuestCommand,
    required DeleteAnsweredQuestCommand deleteAnsweredQuestCommand,
  }) : _createPatientCommand = createPatientCommand,
       _getPatientCommand = getPatientCommand,
       _getPatientsCommand = getPatientsCommand,
       _updatePatientCommand = updatePatientCommand,
       _deletePatientCommand = deletePatientCommand,
       _createAnsweredQuestCommand = createAnsweredQuestCommand,
       _getAnsweredQuestCommand = getAnsweredQuestCommand,
       _getAnsweredQuestsCommand = getAnsweredQuestsCommand,
       _updateAnsweredQuestCommand = updateAnsweredQuestCommand,
       _deleteAnsweredQuestCommand = deleteAnsweredQuestCommand {
    // Observers para cada comando
    _observeCreatePatient();
    _observeGetPatient();
    _observeGetPatients();
    _observeUpdatePatient();
    _observeDeletePatient();
    _observeCreateAnsweredQuest();
    _observeGetAnsweredQuest();
    _observeGetAnsweredQuests();
    _observeUpdateAnsweredQuest();
    _observeDeleteAnsweredQuest();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  CreatePatientCommand get createPatientCommand => _createPatientCommand;
  GetPatientCommand get getPatientCommand => _getPatientCommand;
  GetPatientsCommand get getPatientsCommand => _getPatientsCommand;
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
        state.patientSuccessEvent.value = PatientSuccessEvent.created;
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

  void _observeGetPatients() {
    _observeCommand<List<Patient>>(
      _getPatientsCommand,
      onSuccess: (patients) {
        state.setPatients(patients);
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
        state.patientSuccessEvent.value = PatientSuccessEvent.updated;
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
        state.patientSuccessEvent.value = PatientSuccessEvent.deleted;
        state.setPatient(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeCreateAnsweredQuest() {
    _observeCommand<AnsweredQuest>(
      _createAnsweredQuestCommand,
      onSuccess: (answeredQuest) {
        state.setAnsweredQuest(answeredQuest);
        state.answeredQuestSuccessEvent.value =
            AnsweredQuestSuccessEvent.created;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetAnsweredQuest() {
    _observeCommand<AnsweredQuest>(
      _getAnsweredQuestCommand,
      onSuccess: (answeredQuest) {
        state.setAnsweredQuest(answeredQuest);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      }, //redundante, pois o generico já faz isso, mas mantido para verificar minha suposição
    );
  }

  void _observeGetAnsweredQuests() {
    _observeCommand<List<AnsweredQuest>>(
      _getAnsweredQuestsCommand,
      onSuccess: (answeredQuests) {
        state.setAnsweredQuests(answeredQuests);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      }, //redundante, pois o generico já faz isso, mas mantido para verificar minha suposição
    );
  }

  void _observeUpdateAnsweredQuest() {
    _observeCommand<AnsweredQuest>(
      _updateAnsweredQuestCommand,
      onSuccess: (answeredQuest) {
        state.setAnsweredQuest(answeredQuest);
        state.answeredQuestSuccessEvent.value =
            AnsweredQuestSuccessEvent.updated;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeDeleteAnsweredQuest() {
    _observeCommand<void>(
      _deleteAnsweredQuestCommand,
      onSuccess: (_) {
        state.answeredQuestSuccessEvent.value =
            AnsweredQuestSuccessEvent.deleted;
        state.setAnsweredQuest(null);
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

  Future<void> getPatients(String researchId, String groupId) async {
    await _getPatientsCommand.executeWith((
      researchId: researchId,
      groupId: groupId,
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

  Future<void> createAnsweredQuest(AnsweredQuest answeredQuest) async {
    await _createAnsweredQuestCommand.executeWith((
      answeredQuest: answeredQuest,
    ));
  }

  Future<void> getAnsweredQuest(String answeredQuestId) async {
    await _getAnsweredQuestCommand.executeWith((
      answeredQuestId: answeredQuestId,
    ));
  }

  Future<void> getAnsweredQuests(String patientId) async {
    await _getAnsweredQuestsCommand.executeWith((patientId: patientId));
  }

  Future<void> updateAnsweredQuest(AnsweredQuest answeredQuest) async {
    await _updateAnsweredQuestCommand.executeWith((
      answeredQuest: answeredQuest,
    ));
  }

  Future<void> deleteAnsweredQuest(String answeredQuestId) async {
    await _deleteAnsweredQuestCommand.executeWith((
      answeredQuestId: answeredQuestId,
    ));
  }
}
