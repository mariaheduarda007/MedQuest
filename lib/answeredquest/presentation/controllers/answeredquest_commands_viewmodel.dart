import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import 'package:medquest/answeredquest/presentation/commands/answeredquest_commands.dart';
import 'package:medquest/answeredquest/presentation/controllers/answeredquest_state_viewmodel.dart';

import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';

import 'package:signals_flutter/signals_flutter.dart';

class AnsweredQuestCommandsViewModel {
  final AnsweredQuestStateViewModel state;
  final CreateAnsweredQuestCommand _createAnsweredQuestCommand;
  final GetAnsweredQuestCommand _getAnsweredQuestCommand;
  final GetAnsweredQuestsCommand _getAnsweredQuestsCommand;
  final UpdateAnsweredQuestCommand _updateAnsweredQuestCommand;
  final DeleteAnsweredQuestCommand _deleteAnsweredQuestCommand;

  AnsweredQuestCommandsViewModel({
    required this.state,
    
    required CreateAnsweredQuestCommand createAnsweredQuestCommand,
    required GetAnsweredQuestCommand getAnsweredQuestCommand,
    required GetAnsweredQuestsCommand getAnsweredQuestsCommand,
    required UpdateAnsweredQuestCommand updateAnsweredQuestCommand,
    required DeleteAnsweredQuestCommand deleteAnsweredQuestCommand,
  }) : 
       _createAnsweredQuestCommand = createAnsweredQuestCommand,
       _getAnsweredQuestCommand = getAnsweredQuestCommand,
       _getAnsweredQuestsCommand = getAnsweredQuestsCommand,
       _updateAnsweredQuestCommand = updateAnsweredQuestCommand,
       _deleteAnsweredQuestCommand = deleteAnsweredQuestCommand {
    // Observers para cada comando
    _observeCreateAnsweredQuest();
    _observeGetAnsweredQuest();
    _observeGetAnsweredQuests();
    _observeUpdateAnsweredQuest();
    _observeDeleteAnsweredQuest();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  CreateAnsweredQuestCommand get createAnsweredQuestCommand => _createAnsweredQuestCommand;
  GetAnsweredQuestCommand get getAnsweredQuestCommand => _getAnsweredQuestCommand;
  GetAnsweredQuestsCommand get getAnsweredQuestsCommand => _getAnsweredQuestsCommand;
  UpdateAnsweredQuestCommand get updateAnsweredQuestCommand => _updateAnsweredQuestCommand;
  DeleteAnsweredQuestCommand get deleteAnsweredQuestCommand => _deleteAnsweredQuestCommand;

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


