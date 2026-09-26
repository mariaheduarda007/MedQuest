import '../../../core/typedefs/type_defs.dart';

abstract interface class IModelQuestFacadeUseCases {
  Future<ModelQuestResult> createModelQuest(ModelQuestParams params);
  Future<ModelQuestResult> getModelQuest(ModelQuestIdParams params);
  Future<ModelQuestsResult> getAllModelQuests(NoParams params);
  Future<ModelQuestsResult> getModelQuestsFromResearch(ResearchIdParams params);
  Future<ModelQuestResult> updateModelQuest(ModelQuestParams params);
  Future<VoidResult> deleteModelQuest(ModelQuestIdParams params);
  Future<QuestionResult> createQuestion(QuestionParams params);
  Future<QuestionResult> updateQuestion(QuestionParams params);
  Future<VoidResult> deleteQuestion(QuestionParams params);
}
