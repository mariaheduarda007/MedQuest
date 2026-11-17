import 'package:medquest/modelquest/presentation/controllers/modelquests_state_viewmodel.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../domain/models/modelquest_entity.dart';
import '../commands/modelquest_commands.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ModelQuestsCommandsViewModel {
  final ModelQuestsStateViewModel state;
  //Administrador nao esta vinculado a pesquisa mas ve todos os modelquests, ou pode estar vinculado à todas
  final GetAllModelQuestsCommand _getAllModelQuestsCommand;
  final GetModelQuestsFromResearchCommand _getModelQuestsFromResearchCommand;
  final CreateModelQuestCommand _createModelQuestCommand;

  ModelQuestsCommandsViewModel({
    required this.state,
    required CreateModelQuestCommand createModelQuestCommand,
    required GetAllModelQuestsCommand getAllModelQuestsCommand,
    required GetModelQuestsFromResearchCommand
    getModelQuestsFromResearchCommand,
  }) : _createModelQuestCommand = createModelQuestCommand,
       _getAllModelQuestsCommand = getAllModelQuestsCommand,
       _getModelQuestsFromResearchCommand = getModelQuestsFromResearchCommand {
    _observeCreateModelQuest();
    _observeGetAllModelQuests();
    _observeGetModelQuestsFromResearch();
  }

  CreateModelQuestCommand get createModelQuestCommand =>
      _createModelQuestCommand;
  GetAllModelQuestsCommand get getAllModelQuestsCommand =>
      _getAllModelQuestsCommand;
  GetModelQuestsFromResearchCommand get getModelQuestsFromResearchCommand =>
      _getModelQuestsFromResearchCommand;

  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      if (command.isExecuting.value) return;

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
          command.clear();
        },
      );
    });
  }

  void _observeCreateModelQuest() {
    _observeCommand<ModelQuest>(
      _createModelQuestCommand,
      onSuccess: (modelQuest) {
        state.modelQuestSuccessEvent.value = ModelQuestsSuccessEvent.created;
        state.setModelQuest(modelQuest);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetAllModelQuests() {
    _observeCommand<List<ModelQuest>>(
      _getAllModelQuestsCommand,
      onSuccess: (modelQuests) {
        state.setModelQuests(modelQuests);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetModelQuestsFromResearch() {
    _observeCommand<List<ModelQuest>>(
      _getModelQuestsFromResearchCommand,
      onSuccess: (modelQuests) {
        state.setModelQuests(modelQuests);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  Future<void> createModelQuest(ModelQuest modelQuest) async {
    await _createModelQuestCommand.executeWith((modelQuest: modelQuest));
  }

  Future<void> getAllModelQuests() async {
    await _getAllModelQuestsCommand.executeWith(());
  }

  Future<void> getModelQuestsFromResearch(String researchId) async {
    await _getModelQuestsFromResearchCommand.executeWith((
      researchId: researchId,
    ));
  }
}
