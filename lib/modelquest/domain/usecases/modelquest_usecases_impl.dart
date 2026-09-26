import '../../../core/typedefs/type_defs.dart';
import '../../data/repository/modelquest_repository_interface.dart';
import 'modelquest_usecases_interface.dart';

final class CreateModelQuestUseCaseImpl implements ICreateModelQuestUseCase {
  final IModelQuestRepository _repository;

  CreateModelQuestUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<ModelQuestResult> call(ModelQuestParams params) async {
    return _repository.createModelQuest(params.modelQuest);
  }
}

final class GetModelQuestUseCaseImpl implements IGetModelQuestUseCase {
  final IModelQuestRepository _repository;

  GetModelQuestUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<ModelQuestResult> call(ModelQuestIdParams params) async {
    return _repository.getModelQuest(params.modelQuestId);
  }
}

final class GetAllModelQuestsUseCaseImpl implements IGetAllModelQuestsUseCase {
  final IModelQuestRepository _repository;

  GetAllModelQuestsUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<ModelQuestsResult> call(NoParams params) async {
    return _repository.getAllModelQuests();
  }
}

final class GetModelQuestsFromResearchUseCaseImpl
    implements IGetModelQuestsFromResearchUseCase {
  final IModelQuestRepository _repository;

  GetModelQuestsFromResearchUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<ModelQuestsResult> call(ResearchIdParams params) async {
    return _repository.getModelQuestsFromResearch(params.researchId);
  }
}

final class UpdateModelQuestUseCaseImpl implements IUpdateModelQuestUseCase {
  final IModelQuestRepository _repository;

  UpdateModelQuestUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<ModelQuestResult> call(ModelQuestParams params) async {
    return _repository.updateModelQuest(params.modelQuest);
  }
}

final class DeleteModelQuestUseCaseImpl implements IDeleteModelQuestUseCase {
  final IModelQuestRepository _repository;

  DeleteModelQuestUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(ModelQuestIdParams params) async {
    return _repository.deleteModelQuest(params.modelQuestId);
  }
}

final class CreateQuestionUseCaseImpl implements ICreateQuestionUseCase {
  final IModelQuestRepository _repository;

  CreateQuestionUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<QuestionResult> call(QuestionParams params) async {
    return _repository.createQuestion(params.modelQuestId, params.question);
  }
}

final class UpdateQuestionUseCaseImpl implements IUpdateQuestionUseCase {
  final IModelQuestRepository _repository;

  UpdateQuestionUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<QuestionResult> call(QuestionParams params) async {
    return _repository.updateQuestion(params.modelQuestId, params.question);
  }
}

final class DeleteQuestionUseCaseImpl implements IDeleteQuestionUseCase {
  final IModelQuestRepository _repository;

  DeleteQuestionUseCaseImpl({required IModelQuestRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(QuestionParams params) async {
    return _repository.deleteQuestion(params.modelQuestId, params.question.id);
  }
}
