import '../../../core/typedefs/type_defs.dart';
import '../../domain/models/modelquest_entity.dart';
import '../../domain/models/question_entity.dart';

abstract interface class IModelQuestRepository {
  Future<ModelQuestResult> createModelQuest(ModelQuest modelQuest);
  Future<ModelQuestResult> getModelQuest(String modelQuestId);
  Future<ModelQuestsResult> getAllModelQuests();
  Future<ModelQuestsResult> getModelQuestsFromResearch(String researchId);
  Future<ModelQuestResult> updateModelQuest(ModelQuest modelQuest);
  Future<VoidResult> deleteModelQuest(String modelQuestId);
  Future<QuestionResult> createQuestion(String modelQuestId, Question question);
  Future<QuestionResult> updateQuestion(String modelQuestId, Question question);
  Future<VoidResult> deleteQuestion(String modelQuestId, String questionId);
}
