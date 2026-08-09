import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../domain/models/modelquest_entity.dart';
import '../../domain/models/question_entity.dart';
import '../commands/modelquest_commands.dart';
import 'modelquest_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ModelQuestCommandsViewModel {
  final ModelQuestStateViewModel state;
  final GetModelQuestCommand _getModelQuestCommand;
  final GetAllModelQuestsCommand _getAllModelQuestsCommand;
  final GetModelQuestsFromResearchCommand _getModelQuestsFromResearchCommand;
  final CreateModelQuestCommand _createModelQuestCommand;
  final UpdateModelQuestCommand _updateModelQuestCommand;
  final DeleteModelQuestCommand _deleteModelQuestCommand;
  final CreateQuestionCommand _createQuestionCommand;
  final UpdateQuestionCommand _updateQuestionCommand;
  final DeleteQuestionCommand _deleteQuestionCommand;

  ModelQuestCommandsViewModel({
    required this.state,
    required CreateModelQuestCommand createModelQuestCommand,
    required GetModelQuestCommand getModelQuestCommand,
    required GetAllModelQuestsCommand getAllModelQuestsCommand,
    required GetModelQuestsFromResearchCommand getModelQuestsFromResearchCommand,
    required UpdateModelQuestCommand updateModelQuestCommand,
    required DeleteModelQuestCommand deleteModelQuestCommand,
    required CreateQuestionCommand createQuestionCommand,
    required UpdateQuestionCommand updateQuestionCommand,
    required DeleteQuestionCommand deleteQuestionCommand,
  }) : _createModelQuestCommand = createModelQuestCommand,
       _getModelQuestCommand = getModelQuestCommand,
       _getAllModelQuestsCommand = getAllModelQuestsCommand,
       _getModelQuestsFromResearchCommand = getModelQuestsFromResearchCommand,
       _updateModelQuestCommand = updateModelQuestCommand,
       _deleteModelQuestCommand = deleteModelQuestCommand,
       _createQuestionCommand = createQuestionCommand,
       _updateQuestionCommand = updateQuestionCommand,
       _deleteQuestionCommand = deleteQuestionCommand {
    _observeCreateModelQuest();
    _observeGetModelQuest();
    _observeGetAllModelQuests();
    _observeGetModelQuestsFromResearch();
    _observeUpdateModelQuest();
    _observeDeleteModelQuest();
    _observeCreateQuestion();
    _observeUpdateQuestion();
    _observeDeleteQuestion();
  }

  CreateModelQuestCommand get createModelQuestCommand => _createModelQuestCommand;
  GetModelQuestCommand get getModelQuestCommand => _getModelQuestCommand;
  GetAllModelQuestsCommand get getAllModelQuestsCommand => _getAllModelQuestsCommand;
  GetModelQuestsFromResearchCommand get getModelQuestsFromResearchCommand => _getModelQuestsFromResearchCommand;
  UpdateModelQuestCommand get updateModelQuestCommand => _updateModelQuestCommand;
  DeleteModelQuestCommand get deleteModelQuestCommand => _deleteModelQuestCommand;
  CreateQuestionCommand get createQuestionCommand => _createQuestionCommand;
  UpdateQuestionCommand get updateQuestionCommand => _updateQuestionCommand;
  DeleteQuestionCommand get deleteQuestionCommand => _deleteQuestionCommand;

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
        state.modelQuestSuccessEvent.value = ModelQuestSuccessEvent.created;
        state.setModelQuest(modelQuest);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetModelQuest() {
    _observeCommand<ModelQuest>(
      _getModelQuestCommand,
      onSuccess: (modelQuest) {
        state.setModelQuest(modelQuest);
        state.clearMessage();
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

  void _observeUpdateModelQuest() {
    _observeCommand<ModelQuest>(
      _updateModelQuestCommand,
      onSuccess: (modelQuest) {
        state.modelQuestSuccessEvent.value = ModelQuestSuccessEvent.updated;
        state.setModelQuest(modelQuest);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeDeleteModelQuest() {
    _observeCommand<void>(
      _deleteModelQuestCommand,
      onSuccess: (_) {
        state.modelQuestSuccessEvent.value = ModelQuestSuccessEvent.deleted;
        state.setModelQuest(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeCreateQuestion() {
    _observeCommand<Question>(
      _createQuestionCommand,
      onSuccess: (question) {
        state.questionSuccessEvent.value = QuestionSuccessEvent.created;
        state.setQuestion(question);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeUpdateQuestion() {
    _observeCommand<Question>(
      _updateQuestionCommand,
      onSuccess: (question) {
        state.questionSuccessEvent.value = QuestionSuccessEvent.updated;
        state.setQuestion(question);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeDeleteQuestion() {
    _observeCommand<void>(
      _deleteQuestionCommand,
      onSuccess: (_) {
        state.questionSuccessEvent.value = QuestionSuccessEvent.deleted;
        state.setQuestion(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  Future<void> createModelQuest(ModelQuest modelQuest) async {
    await _createModelQuestCommand.executeWith((modelQuest: modelQuest));
  }

  Future<void> getModelQuest(String modelQuestId) async {
    await _getModelQuestCommand.executeWith((modelQuestId: modelQuestId));
  }

  Future<void> getAllModelQuests() async {
    await _getAllModelQuestsCommand.executeWith(());
  }

  Future<void> getModelQuestsFromResearch(String researchId) async {
    await _getModelQuestsFromResearchCommand.executeWith((researchId: researchId));
  }

  Future<void> updateModelQuest(ModelQuest modelQuest) async {
    await _updateModelQuestCommand.executeWith((modelQuest: modelQuest));
  }

  Future<void> deleteModelQuest(String modelQuestId) async {
    await _deleteModelQuestCommand.executeWith((modelQuestId: modelQuestId));
  }

  Future<void> createQuestion(String modelQuestId, Question question) async {
    await _createQuestionCommand.executeWith((modelQuestId: modelQuestId, question: question));
  }

  Future<void> updateQuestion(String modelQuestId, Question question) async {
    await _updateQuestionCommand.executeWith((modelQuestId: modelQuestId, question: question));
  }

  Future<void> deleteQuestion(String modelQuestId, Question question) async {
    await _deleteQuestionCommand.executeWith((modelQuestId: modelQuestId, question: question));
  }
}
