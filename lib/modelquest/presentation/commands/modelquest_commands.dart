import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../../core/patterns/result.dart';
import '../../../core/typedefs/type_defs.dart';
import '../../domain/facade/modelquest_facade_usecases_interface.dart';
import '../../domain/models/modelquest_entity.dart';
import '../../domain/models/question_entity.dart';

final class CreateModelQuestCommand
    extends ParameterizedCommand<ModelQuest, Failure, ModelQuestParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  CreateModelQuestCommand(this._modelQuestFacadeUseCases);

  @override
  Future<ModelQuestResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar modelquest.'));
    }

    return await _modelQuestFacadeUseCases.createModelQuest(parameter!);
  }
}

final class GetModelQuestCommand
    extends ParameterizedCommand<ModelQuest, Failure, ModelQuestIdParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  GetModelQuestCommand(this._modelQuestFacadeUseCases);

  @override
  Future<ModelQuestResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar modelquest.'));
    }
    return await _modelQuestFacadeUseCases.getModelQuest(parameter!);
  }
}

final class GetAllModelQuestsCommand
    extends ParameterizedCommand<List<ModelQuest>, Failure, NoParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  GetAllModelQuestsCommand(this._modelQuestFacadeUseCases);

  @override
  Future<ModelQuestsResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar modelquests.'));
    }
    return await _modelQuestFacadeUseCases.getAllModelQuests(parameter!);
  }
}

final class GetModelQuestsFromResearchCommand
    extends ParameterizedCommand<List<ModelQuest>, Failure, ResearchIdParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  GetModelQuestsFromResearchCommand(this._modelQuestFacadeUseCases);

  @override
  Future<ModelQuestsResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar modelquests do research.'));
    }
    return await _modelQuestFacadeUseCases.getModelQuestsFromResearch(parameter!);
  }
}

final class UpdateModelQuestCommand
    extends ParameterizedCommand<ModelQuest, Failure, ModelQuestParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  UpdateModelQuestCommand(this._modelQuestFacadeUseCases);

  @override
  Future<ModelQuestResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar modelquest.'));
    }
    return await _modelQuestFacadeUseCases.updateModelQuest(parameter!);
  }
}

final class DeleteModelQuestCommand
    extends ParameterizedCommand<void, Failure, ModelQuestIdParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  DeleteModelQuestCommand(this._modelQuestFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para excluir modelquest.'));
    }
    return await _modelQuestFacadeUseCases.deleteModelQuest(parameter!);
  }
}

final class CreateQuestionCommand
    extends ParameterizedCommand<Question, Failure, QuestionParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  CreateQuestionCommand(this._modelQuestFacadeUseCases);

  @override
  Future<QuestionResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar questão.'));
    }
    return await _modelQuestFacadeUseCases.createQuestion(parameter!);
  }
}

final class UpdateQuestionCommand
    extends ParameterizedCommand<Question, Failure, QuestionParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  UpdateQuestionCommand(this._modelQuestFacadeUseCases);

  @override
  Future<QuestionResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar questão.'));
    }
    return await _modelQuestFacadeUseCases.updateQuestion(parameter!);
  }
}

final class DeleteQuestionCommand
    extends ParameterizedCommand<void, Failure, QuestionParams> {
  final IModelQuestFacadeUseCases _modelQuestFacadeUseCases;

  DeleteQuestionCommand(this._modelQuestFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para excluir questão.'));
    }
    return await _modelQuestFacadeUseCases.deleteQuestion(parameter!);
  }
}
