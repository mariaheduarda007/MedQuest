
import 'package:medquest/modelquest/domain/models/question_mapper.dart';
import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';

class AnsweredQuestMapper {
  static Map<String, dynamic> toMap(AnsweredQuest answeredQuest) {
    return {
      'id': answeredQuest.id,
      'idModelQuest': answeredQuest.idModelQuest,
      'questions': answeredQuest.questions.map((q) => QuestionMapper.toMap(q)).toList(),
    };
  }

  static AnsweredQuest fromMap(Map<String, dynamic> map) {
    return AnsweredQuest(
      id: map['id']?.toString() ?? '',
      idModelQuest: map['idModelQuest']?.toString() ?? '',
      questions: (map['questions'] as List<dynamic>?)
          ?.map((q) => QuestionMapper.fromMap(q as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

            

