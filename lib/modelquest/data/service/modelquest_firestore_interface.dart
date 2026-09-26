import 'package:medquest/modelquest/domain/models/question_entity.dart';
import '../../../core/typedefs/type_defs.dart';
import '../../domain/models/modelquest_entity.dart';

abstract interface class IModelQuestFirestore {
  Future<ModelQuestResult> createModelQuest(ModelQuest modelQuest);
  Future<ModelQuestResult> getModelQuest(String modelQuestId);
  Future<ModelQuestsResult> getAllModelQuests(); // tela inicial, retorna todos os modelQuests que o usuário tem acesso
  Future<ModelQuestsResult> getModelQuestsFromResearch(String researchId); // tela research, retorna todos os modelQuests de research
  Future<ModelQuestResult> updateModelQuest(ModelQuest modelQuest);
  Future<VoidResult> deleteModelQuest(String modelQuestId);
  Future<QuestionResult> createQuestion(String modelQuestId, Question question); // retorna todas as perguntas de um modelQuest
  Future<QuestionResult> updateQuestion(String modelQuestId, Question question); // retorna todas as perguntas de um modelQuest
  Future<VoidResult> deleteQuestion(String modelQuestId, String questionId); // retorna todas as perguntas de um modelQuest
  
}
