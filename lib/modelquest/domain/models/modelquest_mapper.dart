import 'package:medquest/modelquest/domain/models/question_mapper.dart';
import 'modelquest_entity.dart';

class ModelQuestMapper {
  static Map<String, dynamic> toMap(ModelQuest modelQuest) {
    return {
      'id': modelQuest.id,
      'name': modelQuest.name,
      'questions': modelQuest.questions
          .map((question) => QuestionMapper.toMap(question))
          .toList(),
      
    };
  } 

  static ModelQuest fromMap(Map<String, dynamic> map) {
  return ModelQuest(
    id: map['id'] as String,
    name: map['name'] as String,
    questions: (map['questions'] as List)
        .map((question) => QuestionMapper.fromMap(question))
        .toList(),
  );    
    
}
}
