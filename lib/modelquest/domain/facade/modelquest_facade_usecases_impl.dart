import '../../../core/typedefs/type_defs.dart';
import 'modelquest_facade_usecases_interface.dart';
import '../usecases/modelquest_usecases_interface.dart';

final class ModelQuestFacadeUsecasesImpl implements IModelQuestFacadeUseCases {
  final ICreateModelQuestUseCase _createModelQuestUseCase;
  final IGetModelQuestUseCase _getModelQuestUseCase;
  final IGetAllModelQuestsUseCase _getAllModelQuestsUseCase;
  final IGetModelQuestsFromResearchUseCase _getModelQuestsFromResearchUseCase;
  final IUpdateModelQuestUseCase _updateModelQuestUseCase;
  final IDeleteModelQuestUseCase _deleteModelQuestUseCase;
  final ICreateQuestionUseCase _createQuestionUseCase;
  final IUpdateQuestionUseCase _updateQuestionUseCase;
  final IDeleteQuestionUseCase _deleteQuestionUseCase;

  ModelQuestFacadeUsecasesImpl({
    required ICreateModelQuestUseCase createModelQuestUseCase,
    required IGetModelQuestUseCase getModelQuestUseCase,
    required IGetAllModelQuestsUseCase getAllModelQuestsUseCase,
    required IGetModelQuestsFromResearchUseCase getModelQuestsFromResearchUseCase,
    required IUpdateModelQuestUseCase updateModelQuestUseCase,
    required IDeleteModelQuestUseCase deleteModelQuestUseCase,
    required ICreateQuestionUseCase createQuestionUseCase,
    required IUpdateQuestionUseCase updateQuestionUseCase,
    required IDeleteQuestionUseCase deleteQuestionUseCase,
  }) : _createModelQuestUseCase = createModelQuestUseCase,
       _getModelQuestUseCase = getModelQuestUseCase,
       _getAllModelQuestsUseCase = getAllModelQuestsUseCase,
       _getModelQuestsFromResearchUseCase = getModelQuestsFromResearchUseCase,
       _updateModelQuestUseCase = updateModelQuestUseCase,
       _deleteModelQuestUseCase = deleteModelQuestUseCase,
       _createQuestionUseCase = createQuestionUseCase,
       _updateQuestionUseCase = updateQuestionUseCase,
       _deleteQuestionUseCase = deleteQuestionUseCase;

  @override
  Future<ModelQuestResult> createModelQuest(ModelQuestParams params) {
    return _createModelQuestUseCase(params);
  }

  @override
  Future<ModelQuestResult> getModelQuest(ModelQuestIdParams params) {
    return _getModelQuestUseCase(params);
  }

  @override
  Future<ModelQuestsResult> getAllModelQuests(NoParams params) {
    return _getAllModelQuestsUseCase(params);
  }

  @override
  Future<ModelQuestsResult> getModelQuestsFromResearch(ResearchIdParams params) {
    return _getModelQuestsFromResearchUseCase(params);
  }

  @override
  Future<ModelQuestResult> updateModelQuest(ModelQuestParams params) {
    return _updateModelQuestUseCase(params);
  }

  @override
  Future<VoidResult> deleteModelQuest(ModelQuestIdParams params) {
    return _deleteModelQuestUseCase(params);
  }

  @override
  Future<QuestionResult> createQuestion(QuestionParams params) {
    return _createQuestionUseCase(params);
  }

  @override
  Future<QuestionResult> updateQuestion(QuestionParams params) {
    return _updateQuestionUseCase(params);
  }

  @override
  Future<VoidResult> deleteQuestion(QuestionParams params) {
    return _deleteQuestionUseCase(params);
  }
}
