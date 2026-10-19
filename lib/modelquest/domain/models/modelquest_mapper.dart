import 'package:medquest/modelquest/domain/models/question_mapper.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';
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

  static ModelQuest fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    final List<Question> questions;
    final rawQuestions = map['questions'];
    if (rawQuestions is Iterable) {
      questions = rawQuestions
          .whereType<Map>()
          .map(
            (question) => QuestionMapper.fromMap(
              Map<String, dynamic>.from(question),
            ),
          )
          .toList();
    } else {
      questions = const [];
    }

    final rawId = map['id'];
    final rawName = map['name'];
    return ModelQuest(
      id: rawId is String && rawId.isNotEmpty ? rawId : documentId ?? '',
      name: rawName is String && rawName.isNotEmpty
          ? rawName
          : 'Questionário sem nome',
      questions: questions,
    );
  }
}
