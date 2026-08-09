import '../../../core/typedefs/type_defs.dart';
import 'modelquest_repository_interface.dart';
import '../service/modelquest_firestore_interface.dart';
import '../../domain/models/modelquest_entity.dart';
import '../../domain/models/question_entity.dart';

/// implementação do repositório para ModelQuest

final class ModelQuestRepositoryImpl implements IModelQuestRepository {
  final IModelQuestFirestore _firestore;

  ModelQuestRepositoryImpl({required IModelQuestFirestore firestore})
    : _firestore = firestore;

  @override
  Future<ModelQuestResult> createModelQuest(ModelQuest modelQuest) {
    return _firestore.createModelQuest(modelQuest);
  }

  @override
  Future<ModelQuestResult> getModelQuest(String modelQuestId) {
    return _firestore.getModelQuest(modelQuestId);
  }

  @override
  Future<ModelQuestsResult> getAllModelQuests() {
    return _firestore.getAllModelQuests();
  }

  @override
  Future<ModelQuestsResult> getModelQuestsFromResearch(String researchId) {
    return _firestore.getModelQuestsFromResearch(researchId);
  }

  @override
  Future<ModelQuestResult> updateModelQuest(ModelQuest modelQuest) {
    return _firestore.updateModelQuest(modelQuest);
  }

  @override
  Future<VoidResult> deleteModelQuest(String modelQuestId) {
    return _firestore.deleteModelQuest(modelQuestId);
  }

  @override
  Future<QuestionResult> createQuestion(
    String modelQuestId,
    Question question,
  ) {
    return _firestore.createQuestion(modelQuestId, question);
  }

  @override
  Future<QuestionResult> updateQuestion(
    String modelQuestId,
    Question question,
  ) {
    return _firestore.updateQuestion(modelQuestId, question);
  }

  @override
  Future<VoidResult> deleteQuestion(String modelQuestId, String questionId) {
    return _firestore.deleteQuestion(modelQuestId, questionId);
  }
}
